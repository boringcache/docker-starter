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

## Results checked September 9, 2026

The current integration pins One v1.21.0 to
`90111526eb218a7f1e119ac2b29f765bd4d82734`, using CLI v1.21.0. Its
[read-only release check](https://github.com/boringcache/docker-starter/actions/runs/34315443215)
passed at validation commit `722770169aa80725f3e452b3f47f82208ea5f65f`:
37 seconds for the job, 26 seconds at the build boundary, and 23.2 seconds for
the native Docker command. Both image checks passed and the builder's
package-install layer was cached. These are different timing boundaries.

The original comparison used One v1.20.4 and CLI v1.20.5. The
[BoringCache cold/warm run](https://github.com/boringcache/docker-starter/actions/runs/34253553942)
passed with full job times of 82 and 26 seconds. Five actual upstream changes
then produced these full job times:

| Change | BoringCache | GHCR | GitHub cache | Run |
| --- | ---: | ---: | ---: | --- |
| 1 | 34 s | 32 s | 32 s | [34253912339](https://github.com/boringcache/docker-starter/actions/runs/34253912339) |
| 2 | 30 s | 55 s | 53 s | [34254117440](https://github.com/boringcache/docker-starter/actions/runs/34254117440) |
| 3 | 69 s | 77 s | 110 s | [34254265828](https://github.com/boringcache/docker-starter/actions/runs/34254265828) |
| 4 | 30 s | 48 s | 36 s | [34254538106](https://github.com/boringcache/docker-starter/actions/runs/34254538106) |
| 5 | 34 s | 28 s | 33 s | [34254694820](https://github.com/boringcache/docker-starter/actions/runs/34254694820) |

The five jobs total 197 seconds for BoringCache, 240 for GHCR and 264 for
GitHub cache. BoringCache was not faster in every row. Runner and network
variation, plus differences between the BuildKit implementations, limit
attribution from these single samples. The One v1.21.0 check above confirms
restoration of the earlier cache; it is not a replacement timing comparison.

All 24 measured image builds and image checks passed. The original GitHub
cold job failed during artifact upload after its image checks and cache exports
succeeded. That job failure is retained separately from build success.

All three providers restored the unchanged package-install layer. The
intermittent miss in issue #430 did not reproduce. This validates ordinary
reuse in the public template's single Bake solve; it does not validate the
downstream separate build/export sequence, local builds or complete application
CI. The original five-change validation head is
`d24c1f46e20d83e20862694545bdef0ec09e73f0`; its source matches the captured tip
listed above. This results document is a later documentation-only change.
