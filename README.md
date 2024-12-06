To reproduce, checkout this repo and run `make`.
Need Verilator installed.

I do not expect Verilator to evaluate the wire `bad` to True.
It does though, on all versions that I tried, up to 5.026 (released on June 15 2024).

Issue reported:
https://github.com/verilator/verilator/issues/5186

Issue was fixed in Verilator verison 5.028, with this commit:
https://github.com/verilator/verilator/commit/095b1ccb6772259082301c672afa2273c60b6688
