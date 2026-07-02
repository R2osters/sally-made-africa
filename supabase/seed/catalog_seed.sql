-- supabase/seed/catalog_seed.sql
insert into public.countries (code, name, region, coverage_label) values
  ('JP', 'Japan', 'Asia', 'Excellent Coverage'),
  ('CN', 'China', 'Asia', 'Good Coverage'),
  ('IN', 'India', 'Asia', 'Good Coverage'),
  ('KR', 'South Korea', 'Asia', 'Excellent Coverage'),
  ('TH', 'Thailand', 'Asia', 'Good Coverage'),
  ('FR', 'France', 'Europe', 'Excellent Coverage'),
  ('DE', 'Germany', 'Europe', 'Excellent Coverage'),
  ('IT', 'Italy', 'Europe', 'Good Coverage'),
  ('ES', 'Spain', 'Europe', 'Good Coverage'),
  ('GB', 'United Kingdom', 'Europe', 'Excellent Coverage'),
  ('BR', 'Brazil', 'Americas', 'Good Coverage'),
  ('CA', 'Canada', 'Americas', 'Excellent Coverage'),
  ('MX', 'Mexico', 'Americas', 'Good Coverage'),
  ('US', 'United States', 'Americas', 'Excellent Coverage')
on conflict (code) do nothing;

insert into public.esim_plans
  (country_code, data_gb, validity_days, price_usd, network_label, is_popular) values
  ('JP', 5, 30, 14.99, '5G/LTE', false),
  ('JP', 10, 30, 24.00, '5G/LTE', true),
  ('GB', 10, 30, 19.00, '4G/5G', true),
  ('FR', 10, 30, 18.00, '5G', true),
  ('IT', 8, 30, 17.00, '5G', false),
  ('US', 10, 30, 29.00, '5G/LTE', true);
