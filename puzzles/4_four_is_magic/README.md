# [Four is Magic](https://code.kx.com/q/learn/pb/four-magic/)
Teaches finite state machines and convergence.

My solutions:
- `magic.q` my initial attempt.
- `magic_cached.q` with caching mechanism for converted strings.

## Integer to String Conversion
A core part of this problem is integer to string conversion. As with any programming problem, we begin by thinking about
what exactly happens in this conversion process.

For small numbers (<100), we can [roughly hardcode this](magic.q#L18). 

For larger numbers, we enter the land of denominations (e.x. hundred, thousand, million, etc.). Then we can convert with
the following steps:
- Our starting state consists of the input integer `x` and an empty string `s` representing the converted value.
- We apply each "denomination" in decreasing order of magnitude.
- We finish by converting the resulting "small" number.

But how exactly to we "apply" a denomination? Consider example `6,789`:
- We skip larger denominations such as billion and million.
- The first denomination we apply is the thousands because `6,789>1,000`. We divide by one thousand and recursively
  compute string value `"six"`. We append denomination name `"thousand"`. Finally, we proceed with remainder `789`.
  Resulting state: `(789; "six thousand")`.
- The next denomination is the hundreds (`789>100`). We append recursive result `"seven"` and name `"hundred"`. 
  We proceed with remainder `89`. 
  Resulting state: `(89; "six thousand seven hundred")`.
- We are now at a small number. We append final result `"eighty nine"` to obtain string 
  `"six thousand seven hundred eighty nine"` and terminate.

This denomination logic is specified in the [denom function](magic.q#L7) to be used in the 
[itos conversion function](magic.q#L12). This encapsulation leads to a very flexible and readable solution.
 