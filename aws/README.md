# Laboratorio AWS – Infrastructure as Code + Policy as Code

Este laboratorio es la versión AWS del ejercicio de Infrastructure as Code del módulo.

El objetivo es construir recursos AWS mediante Terraform, reutilizar módulos y validar las configuraciones con OPA/Conftest antes de aplicar los cambios.

## Objetivos

Al finalizar el laboratorio podrás:

1. Crear infraestructura AWS con Terraform.
2. Diseñar y reutilizar módulos Terraform.
3. Usar variables, outputs y etiquetas comunes.
4. Generar un plan Terraform y convertirlo a JSON.
5. Validar el plan mediante políticas Rego con Conftest.
6. Identificar incumplimientos de Policy as Code.
7. Corregir Terraform y volver a validar antes de aplicar la infraestructura.

## Recursos

Se crearán tres recursos principales:

- Amazon S3 Bucket
- Amazon DynamoDB Table
- Amazon CloudWatch Log Group

El ejercicio usa módulos locales para encapsular cada recurso.

## Requisitos

- Terraform instalado.
- Credenciales AWS configuradas mediante el mecanismo estándar de AWS CLI/SDK.
- Una región AWS disponible, por ejemplo `us-east-1`.
- Conftest `v0.70.1` instalado.

### Instalación de Conftest

Para Linux, instala la versión `0.70.1`:

```bash
CONFTEST_VERSION="0.70.1"
ARCH="x86_64"
SYSTEM="Linux"

wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_${SYSTEM}_${ARCH}.tar.gz"

tar xzf "conftest_${CONFTEST_VERSION}_${SYSTEM}_${ARCH}.tar.gz"

sudo mv conftest /usr/local/bin/

conftest --version
```

La instalación debe finalizar mostrando la versión de Conftest instalada.

El provider AWS utilizado es `hashicorp/aws`. La versión se fija a una versión estable para que el laboratorio sea reproducible.

## Identificación del alumno y prevención de colisiones

Cada alumno debe definir únicamente su `student_id` en `terraform.tfvars`.

El laboratorio obtiene automáticamente el ID de la cuenta AWS mediante `aws_caller_identity`. Con esto:

- S3 usa un nombre derivado de `student_id + account_id`.
- DynamoDB usa un nombre derivado de `student_id + account_id`.
- CloudWatch Logs usa un nombre derivado de `student_id`.

Ejemplo:

```hcl
student_id = "aldo"
aws_region = "us-east-1"
```

Si varios alumnos utilizan la misma cuenta AWS, cada uno debe utilizar un `student_id` diferente.

## Estructura

```text
aws/
├── README.md
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars.example
├── modules/
│   ├── s3/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── dynamodb/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── cloudwatch-log-group/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── policy/
    ├── README.md
    ├── aws_required_tags.rego
    └── aws_s3_secure.rego
```

## Ejecución

Ubícate en `aws/environments/dev`.

### 1. Configurar variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edita `terraform.tfvars` con tus valores.

### 2. Inicializar Terraform

```bash
terraform init
```

### 3. Validar

```bash
terraform fmt -recursive
terraform validate
```

### 4. Generar el plan

```bash
terraform plan -out=plan.tfplan
```

### 5. Convertir el plan a JSON

```bash
terraform show -json plan.tfplan > plan.json
```

### 6. Ejecutar Policy as Code

Desde `aws/environments/dev`:

```bash
conftest test plan.json -p ../../policy
```

**En el estado inicial del laboratorio, Conftest debe fallar intencionalmente.** Esto es parte del ejercicio.

Los fallos esperados corresponden a:

- S3 versioning deshabilitado.
- Bloqueo de políticas públicas de S3 deshabilitado.

El objetivo es identificar la regla incumplida y corregir el código Terraform.

### 7. Corregir Terraform

Abre:

```text
aws/modules/s3/main.tf
```

Corrige las configuraciones señaladas por Conftest.

Después de modificar Terraform, vuelve a ejecutar:

```bash
terraform plan -out=plan.tfplan
terraform show -json plan.tfplan > plan.json
conftest test plan.json -p ../../policy
```

El resultado esperado es:

```text
0 failures
```

### 8. Aplicar

**Solo después de que las políticas pasen:**

```bash
terraform apply plan.tfplan
```

### 9. Destruir

Al finalizar el laboratorio:

```bash
terraform destroy
```

## Solución del ejercicio

> Esta sección puede utilizarse como guía del instructor o como solución después de que el estudiante haya intentado resolver el ejercicio.

En `aws/modules/s3/main.tf`, la configuración correcta debe ser:

```hcl
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

Después de aplicar estos cambios:

```bash
terraform plan -out=plan.tfplan
terraform show -json plan.tfplan > plan.json
conftest test plan.json -p ../../policy
```

Conftest debe finalizar sin incumplimientos de política.

## Dinámica sugerida para clase

1. Revisar la infraestructura Terraform.
2. Ejecutar `terraform plan`.
3. Convertir el plan a JSON.
4. Ejecutar Conftest y observar los incumplimientos intencionales.
5. Identificar qué regla Rego está fallando.
6. Corregir Terraform.
7. Volver a generar el plan.
8. Ejecutar nuevamente Conftest.
9. Aplicar únicamente cuando el plan cumpla las políticas.
10. Destruir la infraestructura al finalizar.

> Nota: el laboratorio está separado de la implementación Azure existente del repositorio para que ambos ejercicios puedan ejecutarse de manera independiente.
