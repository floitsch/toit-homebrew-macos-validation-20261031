# Temporary Toit Homebrew validation

Runs the Toit 2.0.0 Homebrew formula on GitHub-hosted Apple Silicon and Intel macOS workers.

The formula is based on [floitsch/homebrew-core commit 81c9c1081b035f7de05d6bac20236caf106eb38e](https://github.com/floitsch/homebrew-core/commit/81c9c1081b035f7de05d6bac20236caf106eb38e), with the description updated to "High-level programming language and SDK".

Each worker builds from source, runs functional tests, performs the strict online audit, checks style and linkage, verifies stable-release detection, and runs `brew lgtm --online`. Logs are retained as workflow artifacts for seven days.

The workflow uses read-only repository permissions. AI assistance: Codex (GPT-6) prepared this temporary validation setup.
