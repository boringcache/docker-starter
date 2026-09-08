# Docker Starter cache validation

This fork validates the public builder and frontend images discussed in
[issue #430](https://github.com/jolicode/docker-starter/issues/430).
The application, Dockerfiles, and upstream README retain their upstream content.

Run **Connect BoringCache** once and approve the isolated
`boringcache/docker-starter` workspace for this repository's
`boringcache-validation` branch. Measured runs use GitHub OIDC and short-lived
credentials through the pinned BoringCache One Action.

Run **Docker cache fresh validation** to seed both image targets
and consume their caches on fresh runners. Warm BoringCache jobs are
restore-only and fail on missing cache or cache errors. Run
**Docker cache commit validation** with `phase=commit`
after advancing `.github/boringcache-source` and the matching upstream source
tree; all providers publish their resulting caches. `phase=warm` can repeat
the unchanged-source check on a fresh runner.

All providers build PHP 8.5 for linux/amd64 from the same Bake definition,
load both images locally, and check their installed tools. BoringCache uses
its managed Docker adapter; the baselines use GHCR registry cache and GitHub
Actions cache with separate target refs and `mode=max`. The GHCR paths belong
to this fork and contain build caches. Application images are not published.

`.boringcache.toml` owns the workspace, stable cache identity, and Docker
command. The same integration runs with `boringcache docker` outside GitHub.
It uses BoringCache's OIDC identity, managed BuildKit, OCI cache storage, and
product-emitted evidence. The supplied Dockerfiles have no cache mounts or
separate compilation task, so archive, package-store, and compiler adapters
would add a different workload. They are not added to these Docker rows.

Artifacts retain source identity, Bake inputs, Docker versions, image checks,
build-boundary duration, and BoringCache evidence. Final job logs contain
BuildKit cache decisions and post-step output. Build-boundary timing includes
provider setup, cache transfers, and local image loading; full job time also
includes checkout, verification, and evidence upload.

The captured sequence begins at `5a99bb9bfeab347fe4bd70016187469e180224af`
and ends at `382d2990961bb581993181da18c04278e45bc00b`, using the five real
first-parent changes between them. Source parity is checked before each run.
No synthetic Dockerfile change is used to manufacture invalidation.

The downstream project from the issue is unavailable. Successful public
template runs do not identify its intermittent miss's cause or establish a
production reliability rate. Debian, Composer, and remote ADD references
remain as upstream supplied them and may resolve differently over time.
