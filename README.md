## Building

This build usses a GCP Cloud Build [Trigger](https://console.cloud.google.com/cloud-build/triggers/edit/27656c29-05b6-4de4-a69d-3a200f652a30?authuser=1&project=personalsdm-216019).

Push a new `Tag` to trigger a build.  The `Tag` will also be used as the label of the new Image.  The  `cloudbuild.yaml` file at the root of the repo controls the build and pushes to `gcr.io/personalsdm-216019/altjserver`.

Atomist is watching this project for all new image pushes.

If the Checks pass, we'll update this [kustomization.yaml](https://github.com/vonwig/altjservice/blob/main/resources/k8s/deployment/kustomization.yaml) with the new tag and the flux controller in our [demo cluster](https://console.cloud.google.com/kubernetes/workload/overview?authuser=1&project=personalsdm-216019&pageState=(%22savedViews%22:(%22i%22:%22c7e22f704f50495bab535dad8f5ea80f%22,%22c%22:%5B%22gke%2Fus-east1-b%2Fdemo%22%5D,%22n%22:%5B%22default%22,%22atomist%22,%22flux-system%22,%22ingress-nginx%22,%22kube-node-lease%22,%22kube-public%22,%22kube-system%22,%22production%22%5D))) 
will pick it up and do a rolling upgrade.

