<h1 align="center"> Bytebank com Firebase Crashlytics 📊 </h1>

## ℹ️ Sobre o projeto

Aplicação **mobile** desenvolvida durante o curso [Flutter: Firebase Crashlytics, gere relatórios de erro em tempo real](https://cursos.alura.com.br/course/flutter-firebase-crashlytics-relatorios-tempo-real) de Flutter, na plataforma **[Alura](https://www.alura.com.br/)**, pelo instrutor [Leonardo Marinho](https://cursos.alura.com.br/user/leonardomarinho). O Bytebank App é a simulação do aplicativo de um banco, você é capaz de criar contatos, transferir dinheiro, ver transações antigas, alterar o nome do usuário, usando comunicação http e persistência.

## ☁️ Firebase, Exceções e Crashlytics

O **Firebase** é uma suíte de soluções do Google com diversas ferramentos úteis para o desenvolvimento de aplicações, sendo uma delas o **Crashlytics**, solução usada para registrar em tempo real as incidências de erros e problemas que podem afetar o uso da aplicação.

_E para que isso é útil?_ Com esses dados em mãos podemos mapear quais erros estão acontecendo (mesmo aqueles que sozinhos poderíamos não perceber que estão ocorrendo) além de poder dar prioridade para determinados erros no processo de correção, evitando que os usuários abandonem o app ou tenham uma experiência ruim.

> ⚠️ **Um observação:** Alguns erros não são enviados exatamente em tempo real, eles só são enviados na vez seguinte a qual a aplicação for aberta. _E por que isso acontece?_ Pelo Flutter não ser 100% nativo, quando algo _crasha_/quebra nele, isso só é comunicado para a parte nativa posteriormente, quando for aberto novamente.

**Exceções** são acontecimentos excepcionais, que não temos domínio de quando exatamente irão ocorrer, e precisamos capturá-las e tratar de alguma forma. Essas exceções podem ou não causar **falhas fatais**, que seriam falhas que travam ou impedem o funcionamento pleno do app. Aqui estão alguns tipos de exceções:

`Exceções de app:`

- Falta de permissões essenciais
- Falta de espaço em disco
- Falta de memória ram
- Incompatibilidade com o SO

`Èxceções de comunicação (HTTP):`

- Falta de conexão com a internet
- Demora na resposta do servidor
- Falha no servidor
- Rota não encontrada

### 🪧 Códigos HTTP

- `100-199` Respostas de informação
- `200-299` Respostas de sucesso
- `300-399` Redirecionamentos
- `400-499` Erros do cliente
- `500-599` Erros do servidor

### ❌ Erros mais comuns:

- `403` Forbidden: Não autorizado
- `404` Não encontrado
- `500` Requisição ruim (Servidor)
- `503` Serviço indisponível
- `504` Gateway timeout: Demora na requisição

### 🔎 **Identificando erros**

Para inicializar o Firebase Crashlytics, além da preparação de ambiente presente na documentação, também precisamos inicializar e _informar_ que os erros devem ser reportados na `main.dart`, da seguinte maneira:

```dart
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
```

A instrução `FirebaseCrashlytics.instance.recordError(e, null)` envia um erro para o Firebase Crashlytics, mas uma forma de descrever melhor ainda o erro e ajudar o desenvolvedor a identificá-lo é usando pares de chave e valor costumizados, da seguinte forma: `FirebaseCrashlytics.instance.recordError(error, stack)`.

E também, é importante identificar o usuário de alguma forma, usando `FirebaseCrashlytics.instance.setUserIdentifier('identifier')` na `main.dart`, por exemplo.

### 🪲 **Modo Debug**

Quando estamos apenas testando alguns erros não é interessante que eles sejam enviados para o Dashboard do Crashlytics, para evitar _spam_, portanto precisamos verificar se estamos no modo debug ou não, da seguinte maneira:

```dart
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FirebaseCrashlytics.instance.setUserIdentifier('alura123');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
```

E verificar também antes de reportar o erro:

```dart
if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
  FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
  FirebaseCrashlytics.instance
      .setCustomKey('http_body', transactionCreated.toString());

  FirebaseCrashlytics.instance.recordError(e, null);
}
```

### 🗺️ Zoned Error

_Zoned Error_ é usado para mapear zonas de erros da aplicação e conseguir detectar erros que o Flutter sozinho não pode. É capaz de capturar erros no dart, por exemplo, erros de compilação, interpretação ou alguma ação inesperada.

Para usar o Zoned Error, de forma simples, basta inserir o `runApp()` dentro da seguinte instrução:

```dart
  runZonedGuarded<Future<void>>(() async {
   // ...
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
```

## :hammer: Tecnologias usadas

Neste projeto foram usadas as seguintes tecnologias:

> Framework [Flutter](https://flutter.dev/)

> Linguagem [Dart](https://dart.dev/)

> [Firebase](https://firebase.google.com/)

## ✨ Funcionalidades
Esse projeto foi realizado com  base no [projeto anterior](https://github.com/jhoisz/Bytebank-api-v2), de funcionalidades extras, o projeto usa uma [SnackBar](https://docs.flutter.dev/cookbook/design/snackbars), no lugar de Alerts Dialogs, e todos os erros estão configurados para serem capturados pelo Firebase Crashlytics e exibidos no Dashboard.

<p align="center">
  <img src="https://github.com/jhoisz/Bytebank_Crashlytics/blob/main/crashlyticsapp.gif" alt= "Gif colorido da aplicação desenvolvida demonstrando os erros possiveis." />
</p>

O Dashboard do Firebase Crashlytics apresenta diversas vantagens de análise, como por exemplo, o tipo do dispositivo usado, sistema operacional, orientação da tela e do sistema, versão, dentre outros detalhes. Além de, claro, o erro ocorrido em detalhes para facilitar a correção.

<p align="center">
  <img src="https://github.com/jhoisz/Bytebank_Crashlytics/blob/main/crashlytics.gif" alt= "Dashboard do Firebase Crashlytics" />
</p>

## :arrow_forward: Como executar

Primeiro você deve [instalar flutter](https://docs.flutter.dev/get-started/install).

Então, você pode clocar e entrar na pasta do projeto:

```bash
git clone https://github.com/jhoisz/Bytebank_Crashlytics
cd Bytebank_Crashlytics
```
Antes de rodar a aplicação, também é necessário seguir o passo a passo para [configuração do Firebase Crashlytics no Flutter](https://firebase.flutter.dev/docs/crashlytics/overview).

Agora, para testar, você deve instalar os pacotes/dependêncas e usar um dispositivo conectado ao seu computador ou usar um emulador:

```bash
Flutter get packages
flutter run
```
