# Lab 29: Security and RBAC

This lab focuses on Kubernetes security and Role-Based Access Control (RBAC). You will create a Service Account, define a Role, bind the Role to the Service Account, and compare different RBAC resources like Roles, RoleBindings, ClusterRoles, and ClusterRoleBindings.

---

## Prerequisites
- Kubernetes cluster setup
- `kubectl` installed and configured

---

## Steps

### 1. Create a Service Account

Create a Service Account named `pod-reader-sa`:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pod-reader-sa
```

Apply the Service Account:

```bash
kubectl apply -f service-account.yaml
```

---

### 2. Create a Secret for the Service Account Token

Create a Secret to hold the token for the `pod-reader-sa` Service Account:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: pod-reader-sa-token
  annotations:
    kubernetes.io/service-account.name: pod-reader-sa
type: kubernetes.io/service-account-token
```

Apply the Secret:

```bash
kubectl apply -f secret.yaml
```

---

### 3. Define a Role Named `pod-reader`

Create a Role named `pod-reader` that allows read-only access to pods in the namespace:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```

Apply the Role:

```bash
kubectl apply -f role.yaml
```

---

### 4. Bind the `pod-reader` Role to the Service Account

Create a RoleBinding to bind the `pod-reader` Role to the `pod-reader-sa` Service Account:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
subjects:
- kind: ServiceAccount
  name: pod-reader-sa
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

Apply the RoleBinding:

```bash
kubectl apply -f role-binding.yaml
```

---

### 5. Verify the RBAC Configuration

1. **Get the Service Account Token**:
   Retrieve the token from the Secret you created earlier:

   ```bash
   kubectl get secret pod-reader-sa-token -o jsonpath='{.data.token}' | base64 --decode
   ```

2. **Test Access**:
   Use the token to test access to list pods in the namespace:

   ```bash
   kubectl get pods --token=<service-account-token>
   ```

   You should be able to list pods, but not perform other actions like creating or deleting pods.

---

### 5. Comparison Between RBAC Resources

- **Service Account**:
  - An identity for processes running in a pod. Used to authenticate API requests.

- **Role**:
  - Defines a set of permissions within a specific namespace.

- **RoleBinding**:
  - Grants the permissions defined in a Role to a user or Service Account within a specific namespace.

- **ClusterRole**:
  - Similar to a Role but applies cluster-wide, across all namespaces.

- **ClusterRoleBinding**:
  - Grants the permissions defined in a ClusterRole to a user or Service Account across the entire cluster.

---