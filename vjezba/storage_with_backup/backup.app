{application, backup, [
    {description, "Backup app"},
    {vsn, "0.1"},
    {registered, [backup, backup_sup, backup_serv_balancer, backup_serv_number, backup_serv_other]},
    {applications, [
        kernel, stdlib
    ]},
    {mod, {backup, []}},
    {env, []}
]}.