# lancache2adguard

Simple Docker container + script + http server to create and update DNS cache lists.

**NOTE:** The whole nature of how this container functions is kinda terrible. It does an initial generation of the domain list, then simultaniously starts a Python webserver and starts `crond`. That's it. 0 security, 0 complex health checks, and it likely has some major issues.. so use at your own risk (or help me make it better?).

## Inspiration

- [This](https://github.com/AdguardTeam/AdGuardHome/issues/922) GitHub issue on the AdGuardHome repo
- [This](https://gist.github.com/PSSGCSim/abd99f2fe65d9c4cc0443c6fb69daf40) Gist of [PSSGCSim's](https://github.com/PSSGCSim) script (which was used with modification in `create_list.sh`)
