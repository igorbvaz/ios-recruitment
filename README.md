# ios-recruitment
Desafio técnico da Sympla - Browser de usuários do GitHub.

# Instruções para executar o app
- Fazer clone do projeto;
- Executar o comando ```pod install``` na raiz do projeto, onde se encontra o arquivo ```Podfile```;
- Abra o arquivo ```GitHubUsers.xcworkspace``` pelo Xcode;
- Crie um arquivo chamado ```Keys.swift```e o coloque dentro do projeto do Xcode no caminho ```GitHubUsers/GitHubUsers/Model/Service/Keys.swift```;
- O arquivo ```Keys.swift``` deve possuir o seguinte conteúdo:
```Swift
struct Keys {
    static let authorization = "SUA-CHAVE-DO-GITHUB"
}
```
- Você deve substituir "SUA-CHAVE-DO-GITHUB" por uma chave gerada no site do [GitHub](https://github.com/settings/tokens);
- No target ```GitHubUsers``` altere os dados de ```Signing & Capabilities``` para os da sua conta da Apple;
- Pronto! Pode rodar o app no Xcode com ```command+R```.

# Características do projeto
A arquitetura escolhida foi a MVVM-C, em conjunto com RxSwift e View Coding. O projeto possui testes unitários e de interface de usuário. Existe a opção de tema claro (Light Mode) e tema escuro (Dark Mode) introduzido a partir do iOS 13.

## Testes
Os testes unitários foram feitos com o Quick, um framework baseado em BDD (Behavior-Driven Development) para Swift, inspirado pelo RSpec.
Cada arquivo de testes testa as saídas (viewModel.outputs) de uma ```ViewModel``` para determinados valores de entrada (viewModel.inputs).
Também são testados os comportamentos do ```service```e do ```coordinator```, mockados por injeção de dependência na ```ViewModel```.

## Dependências
### Rx
- RxSwift;
- RxCocoa;
- RxDataSources;
- RxGesture;
- RxSwiftExt.

### Requisições HTTP
- Alamofire;
- AlamofireImage.

### Autocomplete para recursos
- R.swift.

### View Coding
- SnapKit.

### Animações
- lottie-ios.

### Testes
- RxTest;
- Quick;
- Nimble.

# Seção de problemas
Para rodar o app num dispositivo físico utilizando uma conta gratuita da Apple especificamente no iOS 13.3.1 você deve substituir a linha 6 do arquivo ```Podfile``` de
```Ruby
use_frameworks!
```
para
```Ruby
#use_frameworks!
```
> Nota: Para executar os testes do projeto certifique-se que a alteração acima **não tenha sido feita** ou seja revertida.
