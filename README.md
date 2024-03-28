# q2a-docker

Stack is deployment for [Question?Answer](https://docs.question2answer.org/) platform. Only configuration
is [setenv.sh](./setenv.sh) with 3 environment properties for Q2A DB connection:

* QA_DB_USER
* QA_DB_PASS
* QA_DB_NAME

## Services

### q2a-web

Build by [q2a.dockerfile](./q2a.dockerfile) FROM php:7.2-apache.

### mysql:5

MySql DB used by Q2A. Root password is logged into server console.
MYSQL_RANDOM_ROOT_PASSWORD: 'yes'

Check ```docker service logs {stack_name}_mysqldb```

## Install as Docker Swarm

* configure [setenv.sh](./setenv.sh) properties
* (optionally) if you customize image uncomment docker.sh build line, or in case you do not like to download docker
  image [mara14/q2a-web](https://hub.docker.com/r/mara14/q2a-web)
* run [docker.sh](./docker.sh) with docker stack deploy command. The docker container needs to be in swarm
  mode (```docker swarm init```).

# Cluster deployment - k8s

## The secretKeyRef config

Edit [mysqldb-secret.yaml](./k8s/mysqldb-secret.yaml) set the MYSQL_PASSWORD for your value encoded by BASE64.

### Deployment and access validation

After k8s configuration ```kubectl apply -f . -n your_namespace``` , you should see following setup:

```
$kubectl get all

NAME                           READY   STATUS    RESTARTS   AGE
pod/mysqldb-5c598f7654-5b6fm   1/1     Running   0          42s
pod/q2a-web-5b5c55754b-t9d2s   1/1     Running   0          42s

NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/mysqldb   ClusterIP   10.106.30.123   <none>        3306/TCP         42s
service/q2a-web   NodePort    10.96.214.251   <none>        9891:32514/TCP   42s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mysqldb   1/1     1            1           42s
deployment.apps/q2a-web   1/1     1            1           42s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/mysqldb-5c598f7654   1         1         1       42s
replicaset.apps/q2a-web-5b5c55754b   1         1         1       42s
```

To recognize URL host:port, use the ```service/q2a-web``` port (here is 32514) and get the cluster external IP. In case
of minicube use

```
$minikube ip
192.168.49.2
```

Finally check the MySql server log to grab the root password:

```
$kubectl logs replicaset.apps/mysqldb-5c598f7654 -n epc-dev |grep "ROOT PASSW"
2024-03-28 21:20:02+00:00 [Note] [Entrypoint]: GENERATED ROOT PASSWORD: <your unique hash>
```

Your service is accessible on URL ```http://192.168.49.2:32514/q2a/index.php``` by values from example above.