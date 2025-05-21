<div align="center">
  <img src="images/logo.webp" alt="Bootcamp Logo" style="width: 360px" /> 
</div>

# Secrets

## O que são Secrets?

Os Secrets são objetos do Kubernetes que armazenam informações sensíveis, como senhas, chaves de API e certificados. Eles são usados para proteger dados confidenciais e evitar que sejam expostos em arquivos de configuração ou no código-fonte.
Os Secrets são armazenados em etcd, o banco de dados do Kubernetes, e podem ser montados como volumes em pods ou passados como variáveis de ambiente. Isso permite que os aplicativos acessem informações sensíveis sem expô-las diretamente no código.

## Criando um Secret
É possível criar um Secret a partir de um arquivo yaml. Aqui está um exemplo de como criar um Secret a partir de um arquivo:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  ROOT_PASSWORD: username
  MYSQL_DATABASE: password
```

Para criar o Secret a partir do arquivo, use o seguinte comando:
```bash
kubectl apply -f secret.yaml
```

## Listando Secrets

Para listar os Secrets criados no cluster, use o seguinte comando:
```bash
kubectl get secrets
```

## Usando Secrets em um Deployment
Para usar um Secret em um Deployment, você pode montá-lo como um volume ou passá-lo como uma variável de ambiente. Aqui está um exemplo de como usar um Secret como variável de ambiente em um Deployment:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: my-image
        env:
        - name: ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: my-secret
              key: ROOT_PASSWORD
          name: MYSQL_DATABASE
          valueFrom:
            secretKeyRef:
              name: my-secret
              key: MYSQL_DATABASE
```

