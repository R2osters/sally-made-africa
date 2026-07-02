-- supabase/migrations/0001_catalog.sql
create table if not exists public.countries (
  code text primary key,
  name text not null,
  region text not null,
  flag_url text,
  coverage_label text
);

create table if not exists public.esim_plans (
  id uuid primary key default gen_random_uuid(),
  country_code text not null references public.countries(code) on delete cascade,
  data_gb numeric not null,
  validity_days int not null,
  price_usd numeric not null,
  network_label text,
  is_popular boolean not null default false
);

create index if not exists esim_plans_country_code_idx
  on public.esim_plans (country_code);

alter table public.countries enable row level security;
alter table public.esim_plans enable row level security;

create policy "countries public read"
  on public.countries for select
  using (true);

create policy "esim_plans public read"
  on public.esim_plans for select
  using (true);
