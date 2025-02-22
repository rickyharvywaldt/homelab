# homelab
My Kubernetes HomeLab

Learning how to build my own Kubernetes HomeLab. It's currently running K3s on Ubuntu Server on my old laptop. Once I get the hang of it, I will be switching to Kairos. 

Quick update: replaced K3s on Ubuntu Server with Talos Linux. 

I had some issues running Homebrew on Linux from ARM64, so I replaced DevPod with [Mise-en-place](https://github.com/jdx/mise).
Run 
```
mise i
```
to install all the dev tools (currently only Kubectl). 
