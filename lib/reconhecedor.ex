defmodule Reconhecedor do


"""
Replacing 2,3,4 match etc

((?:.*?aA.*?){2})aA
$1bB

"""



def usa_regra(palavra,regra, lista\\[],character_idx\\0) do
  # Split a palavra em duas partes. [left,right], na posicao character idx.
  # Aplica usa_regra no primeiro termo do right, e tenta adicionar a lista (caso ja exista, skip).
  # Repete a operacao para todos os valores de character idx entre 0 e o tamanho da palavra
  [a,b] = regra
  cond do
    String.length(palavra)>character_idx->
      {left,right} = String.split_at(palavra,character_idx)
      replaced = left <> String.replace(right,a,b, global: false)

      case Enum.member?(lista,replaced) do
        true -> usa_regra(palavra,regra, lista,character_idx+1)
        false ->usa_regra(palavra,regra, lista++[replaced],character_idx+1)
      end

    true->lista #caso character_idx > tamanho da palavra, terminar.
  end
end


def reduzir_tamanho(lista,tamanho_maximo) do
  # Recebe uma lista de palavras e um tamanho maximo.
  # Retorna a mesma lista de palavras, eliminando palavras com tamanho maior que o permitido.
  Enum.reject(lista, fn a -> String.length(a)>tamanho_maximo end)
end

def aplica_regras(palavra,regras,idx_regra\\0,lista\\[]) do
  #Aplica varias regras a uma palavra, e retorna uma lista com as cadeias geradas.
  case Enum.fetch(regras,idx_regra) do
    {:ok,regra} ->
      resultado_regra = usa_regra(palavra,regra,lista)
      aplica_regras(palavra,regras,idx_regra+1,resultado_regra)
    {:ok,[regra]} ->
      resultado_regra = usa_regra(palavra,regra,lista)
      aplica_regras(palavra,regras,idx_regra+1,resultado_regra)

    :error ->
      lista
  end
end

def aumenta_conjunto(palavras,regras,idx_palavra\\0,conjunto\\[]) do
  # Percorre todas as palavras, e aplica todas as regras a todas as palavras.
  case Enum.fetch(palavras,idx_palavra) do
    {:ok,[palavra]} ->
      nova_aplicacao = aplica_regras(palavra,regras)
      aplicacao_filtrada = Enum.reject(nova_aplicacao, fn b -> Enum.member?(conjunto,b) end)
      aumenta_conjunto(palavras,regras,idx_palavra+1,conjunto++aplicacao_filtrada)
    {:ok,palavra} -> #mesma condicao de cima, mas para listas de palavras unitarias.
      nova_aplicacao = aplica_regras(palavra,regras)
      aplicacao_filtrada = Enum.reject(nova_aplicacao, fn b -> Enum.member?(conjunto,b) end)
      aumenta_conjunto(palavras,regras,idx_palavra+1,conjunto++aplicacao_filtrada)

    :error ->
      conjunto
  end
end

def calcula_conjunto(palavras,regras,w,iteracao\\0) do
  # Aplica aumenta_conjunto ate w permitido vezes, partindo de T0 ate Tw.
  # Cada aplicacao aumenta a lista de palavras que serao trabalhadas.
  case iteracao==w+1 do
    false ->
      conjuntoN = aumenta_conjunto(palavras,regras)
      conjuntoNfiltrado = reduzir_tamanho(conjuntoN,w)
      calcula_conjunto(conjuntoNfiltrado,regras,w,iteracao+1)
    true ->
      palavras
  end
end

def checa_palavra_em_gramatica(palavra,regras,inicio\\["S"]) do
  conjuntoN_mais_1 = calcula_conjunto(inicio,regras,String.length(palavra))
  Enum.member?(conjuntoN_mais_1,palavra)
end

end


"""

Mais alguns exemplos de uso:

input = "nnnAAAnnn"
input2 = [
  ["nnAAnn"],
  ["mmBBmm"],
  ["zzCCzz"],
]
r2 = [
  ["A","a"],
  ["B","b"],
  ["C","c"],
]
r = [
  ["AA","kk"],
  ["A","a"],
  ["nnn","b"]
]


lista = Reconhecedor.usa_regra(input,["AA","bvbcvb"])
IO.inspect lista

IO.inspect Reconhecedor.reduzir_tamanho(lista,11)

IO.inspect Reconhecedor.aplica_regras(input,r)

IO.inspect Reconhecedor.aumenta_conjunto(input2,r2)

IO.inspect Reconhecedor.calcula_conjunto(input2,r2,14)
"""
