# Policy as Code – AWS

Las políticas de este directorio se ejecutan sobre el JSON generado por:

```bash
terraform show -json plan.tfplan > plan.json
```

## Políticas

### aws_required_tags.rego

Exige los siguientes tags en los recursos AWS que corresponden al ejercicio:

- Environment
- ManagedBy
- Owner
- CostCenter

### aws_s3_secure.rego

Valida controles mínimos de S3:

- Versioning habilitado.
- Server-side encryption configurado con AES256.
- Public ACL bloqueado.
- Public bucket policy bloqueada.
- Public bucket restringido.
- Ignore public ACLs habilitado.

## Ejecución

Desde `aws/environments/dev`:

```bash
conftest test plan.json -p ../../policy
```

## Fallos intencionales del laboratorio

El estado inicial de `aws/modules/s3/main.tf` contiene dos configuraciones deliberadamente incorrectas para que Conftest falle:

1. S3 Versioning está en `Disabled`.
2. `block_public_policy` está en `false`.

Estos incumplimientos son intencionales y forman parte del ejercicio.

El estudiante debe interpretar el mensaje de Conftest, localizar la configuración Terraform correspondiente y corregirla.

## Solución

La solución consiste en:

```hcl
versioning_configuration {
  status = "Enabled"
}

block_public_policy = true
```

Después se debe regenerar el plan y volver a ejecutar Conftest:

```bash
terraform plan -out=plan.tfplan
terraform show -json plan.tfplan > plan.json
conftest test plan.json -p ../../policy
```

El objetivo es obtener un plan sin incumplimientos antes de ejecutar `terraform apply`.
