
# Dynamic Inventory setup ansible-inventory-mysql using postgresql

https://github.com/phamhongviet/ansible-inventory-mysql

##### 1. install docker inside the Jupyterlab container (only do this if you are using alpine os)


```sh
%%sh

/sbin/apk update
/sbin/apk add docker

export PATH=$PATH:/usr/bin
```

    fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/APKINDEX.tar.gz
    fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/community/x86_64/APKINDEX.tar.gz
    v3.8.4-135-g058d0e6ce2 [http://dl-cdn.alpinelinux.org/alpine/v3.8/main]
    v3.8.4-115-g089512e5c9 [http://dl-cdn.alpinelinux.org/alpine/v3.8/community]
    OK: 9609 distinct packages available
    OK: 505 MiB in 107 packages


##### 2. pull postgres image from dockerhub


```sh
%%sh
/usr/bin/docker pull postgres:11
```

    11: Pulling from library/postgres
    Digest: sha256:68b49a280d2fbe9330c0031970ebb72015e1272dfa25f0ed7557514f9e5ad7b7
    Status: Image is up to date for postgres:11


##### 3. run a postgres docker container


```sh
%%sh

docker ps | grep postgres &> /dev/null
[ $? != 0 ] && docker rm postgres && docker run --net=host --name postgres -e POSTGRES_PASSWORD=postgres -d postgres && echo "container started" || echo "container alredy exists"
docker ps | grep postgres
```

    container alredy exists
    cf9210a84bc3        postgres                    "docker-entrypoint.s…"   2 hours ago         Up 2 hours                              postgres


##### 4. prepare the database


```sh
%%sh

docker exec postgres /usr/bin/psql -U postgres -c "CREATE DATABASE ansible_inv"
docker exec postgres /usr/bin/psql -U postgres -c "CREATE user ans"
# access to the database
docker exec postgres /usr/bin/psql -U postgres -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ans"
# Usage privileges on the schema
docker exec postgres /usr/bin/psql -U postgres -c "GRANT CONNECT ON DATABASE ansible_inv TO ans"
# all permissions an all tables
docker exec postgres /usr/bin/psql -U postgres -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ans"

# insert schema
docker exec postgres psql -U ans --host=127.0.0.1 --port=5432 -d ansible_inv -c "$(cat inv.sql)"

# show role attributes
docker exec postgres /usr/bin/psql -U postgres -c "\du"
docker exec postgres psql -U ans --host=127.0.0.1 --port=5432 -d ansible_inv -c "\dt"

```

    GRANT
    GRANT
    GRANT
                                       List of roles
     Role name |                         Attributes                         | Member of 
    -----------+------------------------------------------------------------+-----------
     ans       |                                                            | {}
     postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
    
             List of relations
     Schema |   Name   | Type  | Owner 
    --------+----------+-------+-------
     public | mygroups | table | ans
     public | vars     | table | ans
    (2 rows)
    


    ERROR:  database "ansible_inv" already exists
    ERROR:  role "ans" already exists
    ERROR:  relation "mygroups" already exists


##### 5. insert some data


```sh
%%sh
./inv.py --addhost localhost 127.0.0.1
./inv.py --addhostvar 127.0.0.1 t {'test':'test'}
./inv.py --list
./inv.py --host 127.0.0.1
```

    {
        "localhost": {
            "hosts": [
                "127.0.0.1"
            ],
            "children": [],
            "vars": {}
        }
    }
    {
        "t": "{test:test}"
    }


##### 6. testing ansible inventory


```sh
%%sh
export ANSIBLE_INV_CONFIG=$PWD/config.ini 
export INV_SCRIPT=$PWD/inv.py
ansible -i $INV_SCRIPT -m ping all

```

    /home/lars/develop/DB/story-5843/ansible-inventory-mysql/config.ini
    127.0.0.1 | SUCCESS => {
        "ansible_facts": {
            "discovered_interpreter_python": "/usr/bin/python"
        },
        "changed": false,
        "ping": "pong"
    }


     [WARNING]: Platform linux on host 127.0.0.1 is using the discovered Python
    interpreter at /usr/bin/python, but future installation of another Python
    interpreter could change this. See https://docs.ansible.com/ansible/2.8/referen
    ce_appendices/interpreter_discovery.html for more information.



```python

```
