# Policy as Code – AWS

Las políticas de este directorio se ejecutan sobre el JSON generado por:

```bash
terraform show -json plan.tfplan > plan.json
```

## Políticas

### aws_required_tags.rego

Exige los siguientes tags en los recursos creados:

- Environment
- ManagedBy
- Owner
- CostCenter

### aws_s3_secure.rego

Valida controles mínimos de S3:

- Versioning habilitado.
- Server-side encryption configurado.
- Public ACL bloqueado.
- Public bucket policy bloqueada.
- Public bucket restringido.

## Ejecución

Desde `aws/environments/dev`:

```bash
conftest test plan.json -p ../../policy
```

La actividad está diseñada para que el estudiante pueda provocar un fallo de política, identificar la regla incumplida y corregir Terraform antes de aplicar.
