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
        Path initPath = curPath.getParent().getParent().getParent().resolve("matricesToCompute");
        
        //just the name of the file, folder is sorted out below
        String costMatrixFileName;
        String capMatrixFileName;
        Path costMatrixFile;
        Path capMatrixFile;
        
        for(int docNum = 1; docNum <= 12; docNum++){
            costMatrixFileName = "costMatrix" + docNum + ".txt";
            capMatrixFileName = "capMatrix" + docNum + ".txt";
            
            //gets the file paths we need
            costMatrixFile = initPath.resolve(costMatrixFileName);
            capMatrixFile = initPath.resolve(capMatrixFileName);
            
            System.out.println("EMD = " + getEMD(costMatrixFile,capMatrixFile));
        }

    }
    
    public static double getEMD(Path costMatrixFile, Path capMatrixFile) throws IOException{
        //gets the matrix from the file
        double costMultiplier = 1000; //do this for approximation
        int[][] costMatrix = getMatrixFromFile(costMatrixFile,costMultiplier);
        int[][] capMatrix = getMatrixFromFile(capMatrixFile,1);
        
        int source = costMatrix.length-2;
        int sink = costMatrix.length-1;

        MinCostMaxFlow nf = new MinCostMaxFlow();
        int[] maxflow = nf.getMaxFlow(capMatrix,costMatrix,source,sink);
        
        double totalFlow = maxflow[0];
        double totalCost = maxflow[1];
        totalCost = totalCost/costMultiplier;
        
        return totalCost/totalFlow;
        
    }
    
    public static void displayMatrix(int[][] matrix){
        for(int i = 0; i < matrix.length; i++){
            for(int j = 0; j < matrix[i].length; j++){
                System.out.print(matrix[i][j] + " ");
            }
            System.out.println();
        }
    }
    
    public static int[][] getMatrixFromFile(Path fileToRead, double multiplier) throws IOException{
        ArrayList<String> lines = (ArrayList<String>) 
                Files.readAllLines(fileToRead, StandardCharsets.US_ASCII);
        
        ArrayList<Double[]> matrixRows = new ArrayList<Double[]>();
        ArrayList<Double> currentRowNumbers = new ArrayList<Double>();
        String[] currentLine;
        int numColumns = 1;
        double entry;
        
        for(int row=0; row<lines.size(); row++){
            currentRowNumbers.clear();
            currentLine = lines.get(row).split(" ");
            for(int j = 0; j < currentLine.length; j++){
                String currentEntry = currentLine[j];
                if(currentEntry.length() > 0){
                    entry = Double.parseDouble(currentLine[j]);
                    currentRowNumbers.add(entry*multiplier);
                }
            }
            Double[] nums = new Double[currentRowNumbers.size()];
            currentRowNumbers.toArray(nums);
            numColumns = nums.length;
            matrixRows.add(nums);
        }
        
        int[][] matrix = new int[matrixRows.size()][numColumns];
        Double[] currentRow;
        for(int i = 0; i < matrixRows.size(); i++){
            currentRow = matrixRows.get(i);
            for(int j = 0; j < numColumns; j++){
                matrix[i][j] = (int)Math.floor(currentRow[j]);
            }
        }
        return matrix;
    }
    
}
