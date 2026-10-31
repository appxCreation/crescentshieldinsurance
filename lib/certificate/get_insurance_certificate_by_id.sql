-- Public certificate lookup by an unguessable UUID.
-- This returns only the fields printed on the public certificate and does not
-- grant anonymous users SELECT access to the whole insurance_certificates table.
create or replace function public.get_insurance_certificate_by_id(certificate_id uuid)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'id', c.id,
    'insured_name', c.insured_name,
    'contact_number', c.contact_number,
    'cnic', c.cnic,
    'registration_number', c.registration_number,
    'engine_number', c.engine_number,
    'chassis_number', c.chassis_number,
    'period_from', c.period_from,
    'period_to', c.period_to,
    'make', c.make,
    'model', c.model,
    'seat_capacity', c.seat_capacity,
    'certificate_number', to_jsonb(c) ->> 'certificate_number',
    'date_of_issue', coalesce(
      to_jsonb(c) ->> 'date_of_issue',
      to_jsonb(c) ->> 'created_at'
    ),
    'city', to_jsonb(c) ->> 'city',
    'address', to_jsonb(c) ->> 'address',
    'vehicle_make', coalesce(
      to_jsonb(c) ->> 'vehicle_make',
      to_jsonb(c) ->> 'manufacturer'
    ),
    'manufacturing_year', coalesce(
      to_jsonb(c) ->> 'manufacturing_year',
      to_jsonb(c) ->> 'year',
      to_jsonb(c) ->> 'model_year'
    ),
    'vehicle_category', coalesce(
      to_jsonb(c) ->> 'vehicle_category',
      to_jsonb(c) ->> 'vehicle_type'
    ),
    'insurance_package', coalesce(
      to_jsonb(c) ->> 'insurance_package',
      to_jsonb(c) ->> 'package'
    )
  )
  from public.insurance_certificates as c
  where c.id = $1
  limit 1;
$$;

revoke all on function public.get_insurance_certificate_by_id(uuid) from public;
grant execute on function public.get_insurance_certificate_by_id(uuid) to anon, authenticated;
