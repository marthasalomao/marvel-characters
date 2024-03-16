# Marvel Characters App

Este aplicativo iOS permite aos usuários navegar pelos personagens da Marvel, visualizar seus detalhes e marcá-los como favoritos (ainda em desenvolvimento). Ele utiliza a API da Marvel Comics para buscar dados dos personagens.

## Recursos

- Visualize uma lista de personagens da Marvel com suas imagens e nomes.
- Pesquise personagens pelo nome.
- Toque em um personagem para ver seus detalhes, incluindo descrição e quadrinhos associados.
- Marque personagens como favoritos. (Ainda em desenvolvimento)

## Screenshots

<div style="display: flex;">
  <!-- Imagem -->
  <img width="100%" height="auto" src="https://github.com/marthasalomao/marvel-characters/assets/64446599/b2dcdf33-265e-47b8-b6ab-edccee86142f)"/>
</div>


## Tecnologias Utilizadas

O projeto utiliza a arquitetura MVVM (Model-View-ViewModel) para organizar o código de forma clara e modular. Abaixo estão as principais tecnologias e classes utilizadas:

- Model:
```Character```: Representa um personagem da Marvel e contém informações como nome, descrição e lista de quadrinhos.
- View:
```CharacterCell```: Uma célula personalizada para exibir informações sobre um personagem da Marvel. Utilizada na tela principal para mostrar uma grade de personagens.
```CharacterDetailViewController```: Uma view controller para exibir detalhes sobre um personagem específico da Marvel.
- ViewModel:
```CharacterViewModel```: Gerencia a lógica de negócios relacionada aos personagens da Marvel. Responsável por interagir com a ```MarvelAPIService``` para obter dados e fornecer métodos para pesquisar e filtrar personagens.
- Serviço de API:
```MarvelAPIService```: Interage com a API pública da Marvel para recuperar informações sobre personagens. Usa uma chave pública e uma chave privada, juntamente com um hash MD5, para autenticação.
- Extensões:
```String+MD5Hash```: Fornece uma extensão para calcular o hash MD5 de uma string, usado na autenticação com a API da Marvel.
```String+LevenshteinDistance```: Fornece uma extensão para calcular a distância de Levenshtein entre duas strings, usado para classificar os resultados da pesquisa por proximidade de correspondência.

## Paginação

A API da Marvel utiliza paginação para lidar com grandes conjuntos de dados, como personagens e quadrinhos, melhorando a eficiência e escalabilidade das solicitações. Portanto, ajustamos nosso aplicativo para implementar a paginação, garantindo uma experiência de usuário fluida ao carregar uma lista contínua de personagens com scroll infinito.

- Definição do Tamanho da Página: Foi introduzido um parâmetro ```offset``` no ```MarvelAPIService``` para determinar a posição a partir da qual os personagens seriam buscados. O tamanho da página é fixado em 20, mas pode ser ajustado conforme necessário.
- Rastreamento do Estado de Carregamento: Foi adicionada uma propriedade ```isFetching``` no ```CharacterViewModel``` para rastrear se a busca dos personagens está em andamento, evitando múltiplas solicitações simultâneas.
- Ajuste na Função de Busca de Personagens: A função ```fetchCharacters``` no ```CharacterViewModel``` foi modificada para aceitar um parâmetro ```offset```, indicando a posição a partir da qual os personagens devem ser buscados.
- Chamada de Busca de Personagens com Paginação: No método ```fetchCharactersIfNeeded``` do ```CharacterViewModel```, foi ajustada a chamada para ```marvelService.fetchCharacters``` para incluir o ```offset```, calculado multiplicando o número da página atual pelo tamanho da página.
- Atualização da Interface do Usuário: Após o sucesso na busca dos personagens, é realizada a atualização da lista de personagens e a recarga da coleção no ```CharacterViewController```. Além disso, foi ajustada a função ```didUpdateFilteredCharacters``` para recarregar a coleção após a atualização da lista de personagens.

## Uso

1. Clone o repositório.
2. Abra o projeto no Xcode.
3. Rode e execute o aplicativo no simulador do iOS ou em um dispositivo físico.

Nenhuma dependência de terceiros ou CocoaPods é necessária para executar este aplicativo, tornando-o fácil de clonar e executar localmente sem configuração adicional.

## API

API da Marvel

O aplicativo busca dados dos personagens na [API da Marvel Comics](https://developer.marvel.com/docs). Ele utiliza o endpoint ```/characters``` para obter informações sobre os personagens da Marvel. 

## Acessibilidade
Recursos de acessibilidade foram implementados para garantir uma ótima experiência do usuário para todos os usuários. Elementos-chave, como itens da barra de guias e títulos de tela, foram rotulados adequadamente para acessibilidade.

---
