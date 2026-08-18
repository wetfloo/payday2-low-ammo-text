# Payday 2 SuperBLT mod template

## About

Made this for personal use. [`vendor`](vendor/) includes some common source code
for the following:
- [Base PAYDAY 2](https://github.com/steam-test1/Payday-2-LuaJIT-Complete)
- [SuperBLT base mod](https://github.com/diesel-modding/PAYDAY2-SuperBLT-Lua)
- [BeardLib](https://github.com/diesel-modding/PAYDAY-2-BeardLib)

## Getting started

Simply `git clone` like so:

```
git clone --recurse-submodules https://github.com/wetfloo/payday2-superblt-mod-template.git
```

or use the template repo feature.

Next, update [`mod.txt`](src/mod.txt) to make the necessary adjustments to make a mod work.

## LSP/Formatters

If you have [`lua-language-server`](https://github.com/LuaLS/lua-language-server),
it should be able to index included [`vendor`](vendor/) source code.

[`stylua`](https://github.com/JohnnyMorganz/StyLua) should be used to format `.lua` source code.
