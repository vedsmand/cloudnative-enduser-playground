# intro
this repo is intended to be used as a playground for trying out different stuff from the [Cloud Native landscape](https://landscape.cncf.io/)   
It can help spinning up a Kind cluster with a local docker registry + prometheus running, and you can then navigate the different directories and get help with deploying various services from the cncf landscape

## prerequisites

### Docker

### Make

### nohup

### Kubectl

installation of local infra require kubectl. Your used version should not differ more than +-1 from the used cluster version. Please follow [this](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux) installation guide.

### Kind

[Kind Quickstart](https://kind.sigs.k8s.io/docs/user/quick-start/).

If [go](https://go.dev/) is installed on your machine, `kind` can be easily installed as follows:

```bash
go install sigs.k8s.io/kind@v0.22.0
```

If this is not the case, simply download the [kind-v0.22.0](https://github.com/kubernetes-sigs/kind/releases/tag/v0.22.0) binary from the release page. (Other versions will probably work too. :cowboy_hat_face:)

## install the playground

```bash
make install
```

## Cleanup
```bash
make clean
```
