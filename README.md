# Temporary Toit Homebrew validation

Runs the Toit 2.0.0 Homebrew formula on GitHub-hosted Apple Silicon and Intel macOS workers.

The formula is copied unchanged from [floitsch/homebrew-core commit 8624015ddda708f6670126f9568dd3da5f04127e](https://github.com/floitsch/homebrew-core/commit/8624015ddda708f6670126f9568dd3da5f04127e).

Each worker builds from source, verifies that every SDK executable and vessel contains only the worker's native architecture, runs functional tests, performs the strict online audit, checks style and linkage, verifies stable-release detection, and runs `brew lgtm --online`. Logs are retained as workflow artifacts for seven days.

The workflow uses read-only repository permissions. AI assistance: Codex (GPT-6) prepared this temporary validation setup.
