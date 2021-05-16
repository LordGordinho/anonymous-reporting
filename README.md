# endpoints

Os seguintes endpoints estão configurados:

## Usuários (auth)

    /auth - POST - Cria usuário ( passando os parametros: name, email, password)
    /auth/sign_in - POST - Cria a 'sessão' ( utilizando para 'logar' um usuário)
    /auth - DELETE - Apaga o usuário logado
    /auth - PUT - Atualiza o usuário logado
    /auth/sign_out - DELETE - Destroi a  'sessão' ( utilizando para 'deslogar' um usuário)
    /auth/password - PUT - Atualiza a senha do usuario logado ( passando os parametros: password, password_confirmation)

## Denúncias (complaints)

    * Todos os endpoins a seguir demandam da autenticação do usuário *
    /complaints - GET - Retorna todas as denúnicas da base de dados 
    /complaints/:id - GET - Mostra a denúnica do ID enviado
    /complaints/search?q[description_cont]={ passar a palvra por qual quer buscar } - GET - Retorna todas as denúncias quais têm o parâmetro de busca desejado 
    /complaints - POST - Cria uma denúncia ( parametros necessaŕios: description; parâmetros opcionas: lat, long. Por padrão sera criado uma denuncia com o status padrão de 'pending' )
    /complaints/:id - PUT - Atualiza o a denúncia do ID enviado
    /complaints/:id/change_status - PUT - Atualiza o status da denúnica do ID enviado


