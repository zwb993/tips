# k8s 安装dashboard

参考：https://blog.csdn.net/mshxuyi/article/details/108425487

### 1. 下载官网k8s dashboard yaml

``` bash
wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
```

需要科学上网的话，可以打开https://github.com/kubernetes/dashboard/releases，获取最新版本，直接复制粘贴recommended里面的内容。

### 2. 创建pod

``` bash
kubectl apply -f recommended.yaml
```

查看所有的pods

``` bash
kubectl get pods --all-namespaces
```

可以看到多了kubernetes-dashboard的namespace

### 3.  删除并重新简历pods

删除现有的dashboard svc，dashboard 服务的 namespace 是 kubernetes-dashboard，但是该服务的类型是ClusterIP，不便于我们通过浏览器访问，因此需要改成NodePort型的
``` bash
kubectl delete service kubernetes-dashboard --namespace=kubernetes-dashboard
```

创建配置文件, dashboard-svc.yaml (存放路径可以相应修改)

``` bash
tee -a /opt/k8s/dashboard/dashboard-svc.yaml > /dev/null << EOF
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  type: NodePort
  ports:
    - port: 443
      targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard
EOF
```

创建svc

``` bash
kubectl apply -f dashboard-svc.yaml
```

再次查看服务，可以发现dashboard有起来了，并且为nodeport格式，记住nodeport，后面访问时需要

``` bash
kubectl get svc --all-namespaces
```

### 4. 添加权限

想要访问dashboard服务，就要有访问权限，创建kubernetes-dashboard管理员角色

``` bash
tee -a /opt/k8s/dashboard/dashboard-svc-account.yaml > /dev/null << EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: dashboard-admin
  namespace: kube-system
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: dashboard-admin
subjects:
  - kind: ServiceAccount
    name: dashboard-admin
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
EOF
```

执行

``` ba
kubectl apply -f dashboard-svc-account.yaml
```

获取 token

``` bash
kubectl describe secret `kubectl get secret -n kube-system |grep admin|awk '{print $1}'` -n kube-system|grep '^token'|awk '{print $2}'
```

此token在访问页面时需要

访问https://ip:port， ip是本机ip，port是查看服务时映射出来的port，输入token即可登录界面

done~



