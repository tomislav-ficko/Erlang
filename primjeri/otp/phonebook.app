{application, phonebook, [
    {description, "Phonebook app"},
    {vsn, "0.1"},
    {registered, [phonebook, phonebook_sup, phonebook_serv]},
    {applications, [
        kernel, stdlib
    ]},
    {mod, {phonebook, []}},
    {env, []}
]}.