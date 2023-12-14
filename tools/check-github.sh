set -e

# This demo _requires_ a few things:
#
# 1. You need to set GITHUB_USER to your GitHub username.
#
# 2. You need to fork https://github.com/BuoyantIO/real-world-argo-linkerd and
#    https://github.com/BuoyantIO/gitops-faces under the $GITHUB_USER account.
#
# 3. You need to clone the two repos side-by-side in the directory tree, so
#    that "real-world-argo-linkerd" and "gitops-faces" are siblings.
#
# 4. You need your clone of "real-world-argo-linkerd" to be in its "master"
#    branch.
#
# 5. You need your clone of "gitops-faces" to be in its "main" branch.
#
# 6. You need to be running this script from your "argocd-linkerd-demo-2"
#    clone.
#
# This script verifies that all these things are done.
#
# NOTE WELL: We use Makefile-style escaping in several places, because demosh
# needs it.

# First up, is GITHUB_USER set?
if [ -z "$GITHUB_USER" ]; then \
    echo "GITHUB_USER is not set" >&2 ;\
    exit 1 ;\
fi

# OK. Next up: we should be in the argocd-linkerd-demo-2 repo, and our "origin"
# remote should point to a fork of the repo under the $GITHUB_USER account.

origin=$(git remote get-url --all origin)

if [ $(echo "$origin" | grep -c "$GITHUB_USER/argocd-linkerd-demo-2\.git$") -ne 1 ]; then \
    echo "Not in the $GITHUB_USER fork of argocd-linkerd-demo-2" >&2 ;\
    exit 1 ;\
fi

# Next up: we should be in the "master" branch.
if [ $(git branch --show-current) != "master" ]; then \
    echo "Not in the master branch of argocd-linkerd-demo-2" >&2 ;\
    exit 1 ;\
fi

# Next up: we should have a sibling directory called "gitops-faces" that has
# an origin remote pointing to a fork of the repo under the $GITHUB_USER
# account.
if [ ! -d ../gitops-faces ]; then \
    echo "Missing sibling directory ../gitops-faces" >&2 ;\
    exit 1 ;\
else \
    origin=$(git -C ../gitops-faces remote get-url --all origin) ;\
    \
    if [ $(echo "$origin" | grep -c "$GITHUB_USER/gitops-faces\.git$") -ne 1 ]; then \
        echo "../gitops-faces is not the $GITHUB_USER fork of gitops-faces" >&2 ;\
        exit 1 ;\
    fi ;\
    \
    if [ $(git -C ../gitops-faces branch --show-current) != "main" ]; then \
        echo "Not in the main branch of gitops-faces" >&2 ;\
        exit 1 ;\
    fi ;\
fi

set +e
