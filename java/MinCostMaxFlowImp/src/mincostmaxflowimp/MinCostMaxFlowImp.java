/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package mincostmaxflowimp;

import java.io.File;
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
        
        /*int[][] capacity = {{0,2,2,0},{2,0,0,2},{2,0,0,2},{0,2,2,0}};
        int[][] cost = {{0,1,1,0},{1,0,0,1},{1,0,0,1},{0,1,1,0}};
        int source = 0; int sink = 3;
        MinCostMaxFlow nf = new MinCostMaxFlow();
        int[] maxflow = nf.getMaxFlow(capacity,cost,source,sink);
        for(int j = 0; j < maxflow.length; j++){
            System.out.println(maxflow[j]);
        
        }*/
        
        //just the name of the file, folder is sorted out below
        //String currentFileName = "patches.txt";
        String currentFileName = "fMat.txt";
        
        /*
         * The variable initPath indicates the folder where the MATLAB
         *      text documents are stored and that is where we will
         *      be reading from for this program
         */
        Path curLocation = Paths.get("manifest.mf");
        Path curPath = curLocation.toAbsolutePath();
        Path initPath = curPath.getParent().getParent().getParent();
        
        //gets the file path we need
        Path fileToRead = initPath.resolve(currentFileName);
        
        //gets the matrix from the file
        double[][] matrix = getMatrixFromFile(fileToRead);
        
        //reads the matrix obtained
        for(int i = 0; i < matrix.length; i++){
            for(int j = 0; j < matrix[i].length; j++){
                System.out.print(matrix[i][j] + " ");
            }
            System.out.println();
        }

    }
    
    public static double[][] getMatrixFromFile(Path fileToRead) throws IOException{
        ArrayList<String> lines = (ArrayList<String>) 
                Files.readAllLines(fileToRead, StandardCharsets.US_ASCII);
        
        ArrayList<Double[]> matrixRows = new ArrayList<Double[]>();
        ArrayList<Double> currentRowNumbers = new ArrayList<Double>();
        String[] currentLine;
        int numColumns = 1;
        
        for(int row=0; row<lines.size(); row++){
            currentRowNumbers.clear();
            currentLine = lines.get(row).split(" ");
            for(int j = 0; j < currentLine.length; j++){
                if(currentLine[j].length() > 0){
                    currentRowNumbers.add(Double.parseDouble(currentLine[j]));
                }
            }
            Double[] nums = new Double[currentRowNumbers.size()];
            currentRowNumbers.toArray(nums);
            numColumns = nums.length;
            matrixRows.add(nums);
        }
        
        double[][] matrix = new double[matrixRows.size()][numColumns];
        Double[] currentRow;
        for(int i = 0; i < matrixRows.size(); i++){
            currentRow = matrixRows.get(i);
            for(int j = 0; j < numColumns; j++){
                matrix[i][j] = currentRow[j];
            }
        }
        return matrix;
    }
    
}
