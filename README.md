# Temporary Toit Homebrew validation

Runs the Toit 2.0.0 Homebrew formula on GitHub-hosted Apple Silicon and Intel macOS workers.

The formula is copied unchanged from [floitsch/homebrew-core commit 8624015ddda708f6670126f9568dd3da5f04127e](https://github.com/floitsch/homebrew-core/commit/8624015ddda708f6670126f9568dd3da5f04127e).

Each worker builds from source, verifies that every SDK executable and vessel contains only the worker's native architecture, runs functional tests, performs the strict online audit, checks style and linkage, verifies stable-release detection, and runs `brew lgtm --online`. Logs are retained as workflow artifacts for seven days.

The workflow uses read-only repository permissions. AI assistance: Codex (GPT-6) prepared this temporary validation setup.

## Results

[Source build and package validation](https://github.com/floitsch/toit-homebrew-macos-validation-20261031/actions/runs/41223514193) passed on Apple Silicon and Intel for source installation, SDK functional tests, strict online audit, formula style, linkage, release detection, and native-only executable architecture. Every SDK executable and vessel contained only `arm64` on Apple Silicon and only `x86_64` on Intel.

The Apple Silicon job also passed `brew lgtm --online`. The Intel job's final `lgtm` scan found preinstalled merge-conflict markers in the unrelated `rustup.rb` formula after `brew update`; Toit's individual checks passed. [Rerunning the Intel lint checks on a clean core checkout passed](https://github.com/floitsch/toit-homebrew-macos-validation-20261031/actions/runs/41226378100). The full workflow now cleans the disposable worker's core checkout before staging Toit.

The full workflow is manual (`workflow_dispatch`) to avoid rebuilding Intel's CMake dependency on documentation changes. Run it with:

```sh
gh workflow run macos.yml --repo floitsch/toit-homebrew-macos-validation-20261031
```
