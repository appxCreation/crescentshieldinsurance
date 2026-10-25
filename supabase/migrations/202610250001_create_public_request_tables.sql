create table if not exists public.requested_vehicles (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  vehicle_type text not null check (vehicle_type in ('Truck', 'Trailer')),
  vehicle_number text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.service_request (
  id uuid primary key default gen_random_uuid(),
  service_name text not null,
  name text not null,
  phone text not null,
  description text not null,
  created_at timestamptz not null default now()
);

alter table public.requested_vehicles enable row level security;
alter table public.service_request enable row level security;

grant insert on table public.requested_vehicles to anon;
grant insert on table public.service_request to anon;

drop policy if exists allow_anon_vehicle_quote_insert on public.requested_vehicles;
create policy allow_anon_vehicle_quote_insert
  on public.requested_vehicles
  for insert
  to anon
  with check (true);

drop policy if exists allow_anon_service_request_insert on public.service_request;
create policy allow_anon_service_request_insert
  on public.service_request
  for insert
  to anon
  with check (true);
