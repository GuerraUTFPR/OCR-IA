function [] = separaArquivos3(pasta)

folder = pasta ;
dirListing = dir(pasta);

ftreino = fopen ('train.txt', 'w');
fteste = fopen ('test.txt', 'w');
fvalid = fopen ('valid.txt', 'w');
#floss = fopen ('loss.txt', 'w');

#disp(folder);


#fudeu = fopen('fudeu.txt','w');
#--------------------------------TREINO -------------------------------------------------------------------------      
      #disp(fileName);
      modelTrain = fopen('NIST_Train_Upper.txt', 'r');  
      #fprintf(fudeu,"verificando treino\n");                
      while ~feof(modelTrain)           
        aux = fgetl(modelTrain);
        auxFolder = upper(aux(2));        
        auxName = substr(aux, 3,13);
        path = strcat(folder,"/",auxFolder,auxName);
        disp(path);       
        I = imread(path);
        [l,c] = size(I);
        #disp(I);
 #--------------- contagem de pixels preto e branco total da imagem -------------------------------------------
        pixelPreto = 0;
        pixelBranco = 0;          
        for j = 1 : l
          for k = 1 : c
            if I(j,k) == 0
                    pixelPreto = pixelPreto + 1;
             else
                    pixelBranco = pixelBranco + 1;
                  endif
          endfor
        endfor
 #---------------  utilizando sub matrizes para contagem de pixels -------------------------------------------
            #printf("calculando submatrizes da imagem\n");
            qtd_divisao = 4; #definir em quantas submtrizes sera dividido: 2x2 ou 3x3 ou 4x4...
            
            linha_div = [0]; #vetor contendo os indice de "fronteiras" de cada submatriz para linhas
            coluna_div = [0];
            
            vetLPixelPreto = []; #vetor onde sera armazenado pixels pretos
            vetLPixelBranco = []; #vetor onde sera armazenado pixels brancos
            
            qtdPixelPreto2 = 0; #variavel de contagem de pixel preto
            qtdPixelBranco2 = 0; #variavel de contagem de pixel branco
            
            for (i = 2 : qtd_divisao) #laço para construir o vetor de indice de "fronteira", primeiro elemento ser´a sempre 1
              linha_div(end + 1, :) = floor((linha_div(end) + l / qtd_divisao)) - 1; # concatenando um segundo elemento, que e o anterior mais a divisao
              coluna_div(end + 1, :) = floor((coluna_div(end) + c / qtd_divisao)) - 1;
            end           
            
            
            linha_div(end + 1, :) = l; #o ultimo elemento do vetor e o numero total de linhas
            coluna_div(end + 1, :) = c;
            
            #disp(coluna_div);
            
            for(i = 1 : qtd_divisao)  #troca de quadrante vertical
              for(j = 1 : qtd_divisao) # troca de quadante horizontal
              
                for(a = linha_div(i) + 1 : linha_div(i+1))
                  for(b = coluna_div(j) + 1 : coluna_div(j+1))                 
                     if I(a,b) == 0
                      qtdPixelPreto2 = qtdPixelPreto2 + 1;
                    else
                      qtdPixelBranco2 = qtdPixelBranco2 + 1;
                    end 
                    
                  end
                 # printf("\n");
                  
                end
                #printf("Troca de quadrante \n")
                vetLPixelPreto(end + 1, :) = qtdPixelPreto2;
                vetLPixelBranco(end + 1, :) = qtdPixelBranco2;
                qtdPixelBranco2 = 0;            
                qtdPixelPreto2 = 0;
              end
            end
            
          normalizedPreto = (vetLPixelPreto - min(vetLPixelPreto)) / (max(vetLPixelPreto) - min(vetLPixelPreto));              
          normalizedBranco = (vetLPixelBranco - min(vetLPixelBranco)) / (max(vetLPixelBranco) - min(vetLPixelBranco));
          
        for(countBranco = 1 : size(normalizedBranco))
          fprintf(ftreino, "%f ",normalizedBranco(countBranco));                        
        end
        
        for(countPreto = 1 : size(normalizedPreto))
          fprintf(ftreino, "%f ",normalizedPreto(countPreto));
        end
        fprintf(ftreino, "%d", auxFolder)
        fprintf(ftreino, "\n");
 
      endwhile
      fclose(modelTrain);
             
 fclose(ftreino);
       
 #--------------------------------FIM DO TREINO ----------------------------------------------
 
# ------------------------------------TESTE ----------------------------------------------------
      #disp(fileName);
      modelTest = fopen('NIST_Test_Upper.txt', 'r');  
      #fprintf(fudeu,"verificando treino\n");                
      while ~feof(modelTest)           
        aux = fgetl(modelTest);
        auxFolder = upper(aux(2));        
        auxName = substr(aux, 3,13);
        path = strcat(folder,"/",auxFolder,auxName);
        disp(path);       
        I = imread(path);
        [l,c] = size(I);
        #disp(I);
 #--------------- contagem de pixels preto e branco total da imagem -------------------------------------------
        pixelPreto = 0;
        pixelBranco = 0;          
        for j = 1 : l
          for k = 1 : c
            if I(j,k) == 0
                    pixelPreto = pixelPreto + 1;
             else
                    pixelBranco = pixelBranco + 1;
                  endif
          endfor
        endfor
 #---------------  utilizando sub matrizes para contagem de pixels -------------------------------------------
            #printf("calculando submatrizes da imagem\n");
            qtd_divisao = 4; #definir em quantas submtrizes sera dividido: 2x2 ou 3x3 ou 4x4...
            
            linha_div = [0]; #vetor contendo os indice de "fronteiras" de cada submatriz para linhas
            coluna_div = [0];
            
            vetLPixelPreto = []; #vetor onde sera armazenado pixels pretos
            vetLPixelBranco = []; #vetor onde sera armazenado pixels brancos
            
            qtdPixelPreto2 = 0; #variavel de contagem de pixel preto
            qtdPixelBranco2 = 0; #variavel de contagem de pixel branco
            
            for (i = 2 : qtd_divisao) #laço para construir o vetor de indice de "fronteira", primeiro elemento ser´a sempre 1
              linha_div(end + 1, :) = floor((linha_div(end) + l / qtd_divisao)) - 1; # concatenando um segundo elemento, que e o anterior mais a divisao
              coluna_div(end + 1, :) = floor((coluna_div(end) + c / qtd_divisao)) - 1;
            end
            
            
            
            linha_div(end + 1, :) = l; #o ultimo elemento do vetor e o numero total de linhas
            coluna_div(end + 1, :) = c;
            
            #disp(coluna_div);
            
            for(i = 1 : qtd_divisao)  #troca de quadrante vertical
              for(j = 1 : qtd_divisao) # troca de quadante horizontal
              
                for(a = linha_div(i) + 1 : linha_div(i+1))
                  for(b = coluna_div(j) + 1 : coluna_div(j+1))                 
                     if I(a,b) == 0
                      qtdPixelPreto2 = qtdPixelPreto2 + 1;
                    else
                      qtdPixelBranco2 = qtdPixelBranco2 + 1;
                    end 
                    
                  end
                 # printf("\n");
                  
                end
                #printf("Troca de quadrante \n")
                vetLPixelPreto(end + 1, :) = qtdPixelPreto2;
                vetLPixelBranco(end + 1, :) = qtdPixelBranco2;
                qtdPixelBranco2 = 0;            
                qtdPixelPreto2 = 0;
              end
            end
            
          normalizedPreto = (vetLPixelPreto - min(vetLPixelPreto)) / (max(vetLPixelPreto) - min(vetLPixelPreto));              
          normalizedBranco = (vetLPixelBranco - min(vetLPixelBranco)) / (max(vetLPixelBranco) - min(vetLPixelBranco));
          
        for(countBranco = 1 : size(normalizedBranco))
          fprintf(fteste, "%f ",normalizedBranco(countBranco));                        
        end
        
        for(countPreto = 1 : size(normalizedPreto))
          fprintf(fteste, "%f ",normalizedPreto(countPreto));
        end
        fprintf(fteste, "%d", auxFolder)
        fprintf(fteste, "\n");
 
      endwhile
      fclose(modelTest);
      
  fclose(fteste);
#--------------------------------------FIM DO TESTE --------------------------------------------

#-------------------------------------VALID ---------------------------------------------------
      #disp(fileName);
      modelValid = fopen('NIST_Valid_Upper.txt', 'r');  
      #fprintf(fudeu,"verificando treino\n");                
      while ~feof(modelValid)           
        aux = fgetl(modelValid);
        auxFolder = upper(aux(2));        
        auxName = substr(aux, 3,13);
        path = strcat(folder,"/",auxFolder,auxName);
        disp(path);       
        I = imread(path);
        [l,c] = size(I);
        #disp(I);
 #--------------- contagem de pixels preto e branco total da imagem -------------------------------------------
        pixelPreto = 0;
        pixelBranco = 0;          
        for j = 1 : l
          for k = 1 : c
            if I(j,k) == 0
                    pixelPreto = pixelPreto + 1;
             else
                    pixelBranco = pixelBranco + 1;
                  endif
          endfor
        endfor
 #---------------  utilizando sub matrizes para contagem de pixels -------------------------------------------
            #printf("calculando submatrizes da imagem\n");
            qtd_divisao = 4; #definir em quantas submtrizes sera dividido: 2x2 ou 3x3 ou 4x4...
            
            linha_div = [0]; #vetor contendo os indice de "fronteiras" de cada submatriz para linhas
            coluna_div = [0];
            
            vetLPixelPreto = []; #vetor onde sera armazenado pixels pretos
            vetLPixelBranco = []; #vetor onde sera armazenado pixels brancos
            
            qtdPixelPreto2 = 0; #variavel de contagem de pixel preto
            qtdPixelBranco2 = 0; #variavel de contagem de pixel branco
            
            for (i = 2 : qtd_divisao) #laço para construir o vetor de indice de "fronteira", primeiro elemento ser´a sempre 1
              linha_div(end + 1, :) = floor((linha_div(end) + l / qtd_divisao)) - 1; # concatenando um segundo elemento, que e o anterior mais a divisao
              coluna_div(end + 1, :) = floor((coluna_div(end) + c / qtd_divisao)) - 1;
            end
            
            
            
            linha_div(end + 1, :) = l; #o ultimo elemento do vetor e o numero total de linhas
            coluna_div(end + 1, :) = c;
            
            #disp(coluna_div);
            
            for(i = 1 : qtd_divisao)  #troca de quadrante vertical
              for(j = 1 : qtd_divisao) # troca de quadante horizontal
              
                for(a = linha_div(i) + 1 : linha_div(i+1))
                  for(b = coluna_div(j) + 1 : coluna_div(j+1))                 
                     if I(a,b) == 0
                      qtdPixelPreto2 = qtdPixelPreto2 + 1;
                    else
                      qtdPixelBranco2 = qtdPixelBranco2 + 1;
                    end 
                    
                  end
                 # printf("\n");
                  
                end
                #printf("Troca de quadrante \n")
                vetLPixelPreto(end + 1, :) = qtdPixelPreto2;
                vetLPixelBranco(end + 1, :) = qtdPixelBranco2;
                qtdPixelBranco2 = 0;            
                qtdPixelPreto2 = 0;
              end
            end
            
          normalizedPreto = (vetLPixelPreto - min(vetLPixelPreto)) / (max(vetLPixelPreto) - min(vetLPixelPreto));              
          normalizedBranco = (vetLPixelBranco - min(vetLPixelBranco)) / (max(vetLPixelBranco) - min(vetLPixelBranco));
          
        for(countBranco = 1 : size(normalizedBranco))
          fprintf(fvalid, "%f ",normalizedBranco(countBranco));                        
        end
        
        for(countPreto = 1 : size(normalizedPreto))
          fprintf(fvalid, "%f ",normalizedPreto(countPreto));
        end
        fprintf(fvalid, "%d", auxFolder)
        fprintf(fvalid, "\n");
 
      endwhile
      fclose(modelValid);
   fclose(fvalid);
#---------------------------------------FIM DO VALID---------------------------------------------
 

 #fclose(floss);
 
 

 
 #fclose(fudeu);
 
 printf("extraçao de caractristica concluida\n");

endfunction