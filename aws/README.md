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
6. Corregir una configuración que incumple una política antes de aplicar la infraestructura.

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
- Conftest instalado.

El provider AWS utilizado es `hashicorp/aws`. La versión se fija a una versión estable para que el laboratorio sea reproducible.

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

Las políticas deben verificar, entre otros aspectos:

- Tags obligatorios.
- Bloqueo de acceso público en S3.
- Versionado de S3.
- Cifrado de S3.

### 7. Aplicar

Solo después de que las políticas pasen:

```bash
terraform apply plan.tfplan
```

### 8. Destruir

```bash
terraform destroy
```

## Dinámica sugerida para clase

1. Ejecutar `terraform plan`.
2. Convertir el plan a JSON.
3. Ejecutar Conftest y observar que las políticas pasan.
4. Romper intencionalmente una configuración de S3, por ejemplo deshabilitando una protección.
5. Volver a generar el plan.
6. Ejecutar Conftest y observar el fallo.
7. Corregir Terraform.
8. Volver a ejecutar las políticas.
9. Aplicar únicamente cuando el plan cumpla las políticas.

> Nota: el laboratorio está separado de la implementación Azure existente del repositorio para que ambos ejercicios puedan ejecutarse de manera independiente.
