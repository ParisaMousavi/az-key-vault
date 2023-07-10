# Push changes in Azure DevOps Repo & GitHub
```
git remote set-url --add --push origin https://github.com/ParisaMousavi/az-key-vault.git

git remote set-url --add --push origin https://p-moosavinezhad@dev.azure.com/p-moosavinezhad/az-iac/_git/az-key-vault
```

# Push changes in Azure DevOps Repo & GitHub with SSH
```
git remote set-url --add --push origin git@github.com:ParisaMousavi/az-key-vault.git

git remote set-url --add --push origin git@ssh.dev.azure.com:v3/p-moosavinezhad/az-iac/az-key-vault
```

# Create a new tag
```
git tag -a <year.month.day> -m "description"

git push origin <year.month.day>

```

