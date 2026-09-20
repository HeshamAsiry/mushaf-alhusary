-- Mushaf Al-Husary database schema
-- PostgreSQL / Neon
--
-- This schema models:
--   1) the original source recordings,
--   2) the ranges extracted from those recordings,
--   3) rebuilt surah versions,
--   4) review/approval history.
--
-- Audio object prefixes are intentionally separated:
--   raw/       original source files, immutable
--   processed/ rebuilt files before approval
--   public/    approved files only

begin;

create table if not exists surahs (
  id bigint generated always as identity primary key,
  number smallint not null unique,
  name_ar text not null,
  status text not null default 'pending',
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint surahs_number_check check (number between 1 and 114),
  constraint surahs_status_check check (
    status in ('pending', 'building', 'review', 'published')
  )
);

create table if not exists source_segments (
  id bigint generated always as identity primary key,
  source_order integer not null unique,
  title text,
  source_url text,
  youtube_video_id text,
  raw_object_key text not null unique,
  duration_ms bigint,
  sha256 text,
  discovered_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint source_segments_order_check check (source_order > 0),
  constraint source_segments_raw_key_check check (raw_object_key like 'raw/%'),
  constraint source_segments_duration_check check (
    duration_ms is null or duration_ms >= 0
  )
);

create table if not exists surah_source_ranges (
  id bigint generated always as identity primary key,
  surah_id bigint not null references surahs(id) on delete restrict,
  source_segment_id bigint not null references source_segments(id) on delete restrict,
  segment_order integer not null,
  source_start_ms bigint not null,
  source_end_ms bigint not null,
  notes text,
  created_at timestamptz not null default now(),

  constraint surah_source_ranges_order_check check (segment_order > 0),
  constraint surah_source_ranges_time_check check (
    source_start_ms >= 0
    and source_end_ms > source_start_ms
  ),
  unique (surah_id, segment_order)
);

create table if not exists surah_builds (
  id bigint generated always as identity primary key,
  surah_id bigint not null references surahs(id) on delete restrict,
  version integer not null,
  status text not null default 'draft',
  processed_object_key text,
  public_object_key text,
  duration_ms bigint,
  sha256 text,
  input_manifest jsonb not null default '[]'::jsonb,
  audio_metadata jsonb not null default '{}'::jsonb,
  build_notes text,
  rejection_reason text,
  created_at timestamptz not null default now(),
  built_at timestamptz,
  reviewed_at timestamptz,
  published_at timestamptz,

  constraint surah_builds_version_check check (version > 0),
  constraint surah_builds_status_check check (
    status in ('draft', 'processing', 'pending_review', 'approved', 'rejected')
  ),
  constraint surah_builds_processed_key_check check (
    processed_object_key is null or processed_object_key like 'processed/%'
  ),
  constraint surah_builds_public_key_check check (
    public_object_key is null or public_object_key like 'public/%'
  ),
  constraint surah_builds_duration_check check (
    duration_ms is null or duration_ms >= 0
  ),
  unique (surah_id, version)
);

create table if not exists build_reviews (
  id bigint generated always as identity primary key,
  build_id bigint not null references surah_builds(id) on delete restrict,
  decision text not null,
  reviewer_name text,
  notes text,
  created_at timestamptz not null default now(),

  constraint build_reviews_decision_check check (
    decision in ('approved', 'rejected', 'needs_changes')
  )
);

create index if not exists idx_surah_source_ranges_surah
  on surah_source_ranges (surah_id, segment_order);

create index if not exists idx_surah_source_ranges_source
  on surah_source_ranges (source_segment_id);

create index if not exists idx_surah_builds_surah_status
  on surah_builds (surah_id, status, version desc);

create index if not exists idx_build_reviews_build
  on build_reviews (build_id, created_at desc);

commit;
