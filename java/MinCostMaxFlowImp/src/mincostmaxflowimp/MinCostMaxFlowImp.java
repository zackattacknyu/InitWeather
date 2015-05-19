/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package mincostmaxflowimp;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Calendar;

/**
 *
 * @author Zach
 */
public class MinCostMaxFlowImp {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException {
        
        /*
         * The variable initPath indicates the folder where the MATLAB
         *      text documents are stored and that is where we will
         *      be reading from for this program
         */
        Path curLocation = Paths.get("manifest.mf");
        Path curPath = curLocation.toAbsolutePath();
        Path initPath = curPath.getParent().getParent().getParent();
        Path inputPath = initPath.resolve("matricesToCompute");
        
        //just the name of the file, folder is sorted out below
        String costMatrixFileName;
        String capMatrixFileName;
        Path costMatrixFile;
        Path capMatrixFile;
        
        int docNum = 1;

        ArrayList<String> emdResults = new ArrayList<String>(100);
        double currentEMD;
        EmdResults currentResults;
        
        while(true){
            costMatrixFileName = "costMatrix" + docNum + ".txt";
            capMatrixFileName = "capMatrix" + docNum + ".txt";
            
            //gets the file paths we need
            costMatrixFile = inputPath.resolve(costMatrixFileName);
            capMatrixFile = inputPath.resolve(capMatrixFileName);
            
            if(!costMatrixFile.toFile().exists() || !capMatrixFile.toFile().exists()){
                break;
            }
            
            currentResults = new EmdResults(costMatrixFile,capMatrixFile);
            currentEMD = currentResults.getEmd();
            emdResults.add(Double.toString(currentEMD));
            System.out.println("EMD = " + currentEMD);
            
            docNum++;
        }
        
        Path emdResultFile = initPath.resolve("emdResults.txt");
        try {
            Files.write(emdResultFile, emdResults, StandardCharsets.UTF_8);
        } catch (Exception e) {
            e.printStackTrace();
        }
        

    }
    
    public static void displayMatrix(int[][] matrix){
        for(int i = 0; i < matrix.length; i++){
            for(int j = 0; j < matrix[i].length; j++){
                System.out.print(matrix[i][j] + " ");
            }
            System.out.println();
        }
    }
    
    
    
}
