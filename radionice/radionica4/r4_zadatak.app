{application, r4_zadatak, [
    {description, "Bucket sort app"},
    {vsn, "0.1"},
    {registered, [r4_zadatak, bucket_sort_sup, bucket_sort_serv]},
    {applications, [
        kernel, stdlib
    ]},
    {mod, {r4_zadatak, []}},
    {env, []}
]}.