defmodule ReconhecedorTest do
  use ExUnit.Case
  doctest Reconhecedor

  test "testes checa_palavra_em_gramatica" do

    input1 =  "aaa"
    g1 = [["A","S"], ["A","aS"], ["S","a"], ["S","aA"]]
    # resultado esperado: cadeia aceita (A->aS->aaA->aaS->aaa)

    input2 =  "bbab"
    g2 = [["S","aAa"], ["A","a"], ["A","ba"]]
    # resultado esperado: cadeia rejeitada

    input3 =  "aSb"
    g3 = [["S","aA"], ["S","A"], ["A","S"], ["A","Ab"]]
    # resultado esperado: cadeia aceita (S->aA->aAb->aSb)

    input4 = "aabab"
    g4 = [["A","S"], ["A","aS"], ["A","abS"], ["S","A"], ["S","aS"], ["S","b"]]
    # resultado esperado: cadeia aceita (A->aS->aA->aabS->aabaS->aabab)

    input5 = "aaabaa"
    g5 = [["A","S"], ["A","aS"], ["A","abS"], ["S","A"], ["S","aS"]]
    # resultado esperado: cadeia rejeitada


    assert Reconhecedor.checa_palavra_em_gramatica(input1,g1) == true
    assert Reconhecedor.checa_palavra_em_gramatica(input2,g2) == false
    assert Reconhecedor.checa_palavra_em_gramatica(input3,g3) == true
    assert Reconhecedor.checa_palavra_em_gramatica(input4,g4) == true
    assert Reconhecedor.checa_palavra_em_gramatica(input5,g5) == false

  end

  test "testes usa regra" do

    input1 =  "aaaaA"
    r1 = ["A","X"]
    resultado_esperado= Enum.sort(  ["aaaaX"]  )

    input2 =  "aaaAAAaaa"
    r2 = ["A","X"]
    resultado_esperado2= Enum.sort([  "aaaXAAaaa","aaaAXAaaa","aaaAAXaaa","aaaAAAaaa"  ])

    input3 =  "aaSAAaaaSAa"
    r3 = ["aSA","YXZ"]
    resultado_esperado3= Enum.sort([  "aYXZAaaaSAa","aaSAAaaYXZa","aaSAAaaaSAa"  ])

    assert Enum.sort(Reconhecedor.usa_regra(input1,r1)) == resultado_esperado
    assert Enum.sort(Reconhecedor.usa_regra(input2,r2)) == resultado_esperado2
    assert Enum.sort(Reconhecedor.usa_regra(input3,r3)) == resultado_esperado3

  end

  test "testes aplica_regras" do

    input1 =  "aaaaA"
    r1 = [["A","X"],["aA","ZZ"]]
    resultado_esperado= Enum.sort(  [
      "aaaaA",
      "aaaaX",
      "aaaZZ",
      ]  )

    input2 =  "aaaAAAaaa"
    r2 = [["AA","XX"],["aaaA","BBBA"],["Aaaa","ABBB"]]
    resultado_esperado2= Enum.sort([
        "aaaXXAaaa",
        "aaaAXXaaa",
        "BBBAAAaaa",
        "aaaAAABBB",
        "aaaAAAaaa"  ])

    input3 =  "aaSAAaaaSAa"
    r3 = [["aSA","YXZ"],["S",""]]
    resultado_esperado3= Enum.sort([
      "aYXZAaaaSAa",
      "aaSAAaaYXZa",
      "aaAAaaaSAa",
      "aaSAAaaaAa",
      "aaSAAaaaSAa",
        ])

    assert Enum.sort(Reconhecedor.aplica_regras(input1,r1)) == resultado_esperado
    assert Enum.sort(Reconhecedor.aplica_regras(input2,r2)) == resultado_esperado2
    assert Enum.sort(Reconhecedor.aplica_regras(input3,r3)) == resultado_esperado3

  end

  test "testes aumenta conjunto" do

    input1 =  ["aaA","bbB"]
    r1 = [["A","X"],["B","X"]]
    resultado_esperado= Enum.sort(  [
      "aaA",
      "aaX",

      "bbB",
      "bbX",
      ]  )

    input2 =  [["aaaAAAaaa"],["AA"],["AAvvvAAA"]]
    r2 = [["AA","XX"],["aaaA","BBBA"],["Aaaa","ABBB"]]
    resultado_esperado2= Enum.sort([
        "aaaXXAaaa",
        "aaaAXXaaa",
        "BBBAAAaaa",
        "aaaAAABBB",
        "aaaAAAaaa",

        "AA",
        "XX",

        "AAvvvAAA",
        "XXvvvAAA",
        "AAvvvXXA",
        "AAvvvAXX",
        ])

    assert Enum.sort(Reconhecedor.aumenta_conjunto(input1,r1)) == resultado_esperado
    assert Enum.sort(Reconhecedor.aumenta_conjunto(input2,r2)) == resultado_esperado2


  end

  test "testes calcula conjunto" do

    input1 =  ["A"]
    r1 = [["A","aA"],["S","X"]]
    w1= 5 #Isso significa 5 iteracoes, de T0 = "A" ate T6
    resultado_esperado= Enum.sort([
      "A",
      "aA",
      "aaA",
      "aaaA",
      "aaaaA",

#     "aaaaaA", Nao aparece pois tem tamanho = W+1
#     "aaaaaaA", Nao aparece pois tem tamanho = W+2
      ])

    assert Enum.sort(Reconhecedor.calcula_conjunto(input1,r1,w1)) == resultado_esperado


  end

end
