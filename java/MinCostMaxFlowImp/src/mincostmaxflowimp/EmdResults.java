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
import java.util.ArrayList;
import java.util.Calendar;

/**
 *
 * @author Zach
 */
public class EmdResults {
    
    private double emd;
    private int[] sourceFlowVector;
    private int[] sinkFlowVector;
    
    public EmdResults(Path costMatrixFile, Path capMatrixFile) throws IOException{
        
        //gets the matrix from the file
        double costMultiplier = 1000; //do this for approximation
        int[][] costMatrix = getMatrixFromFile(costMatrixFile,costMultiplier);
        int[][] capMatrix = getMatrixFromFile(capMatrixFile,1);
        
        //displayMatrix(capMatrix);
        
        int source = costMatrix.length-2;
        int sink = costMatrix.length-1;

        MinCostMaxFlow nf = new MinCostMaxFlow();
        System.out.println("Entering Max Flow: ");
        long maxFlowStart = Calendar.getInstance().getTimeInMillis();
        int[] maxflow = nf.getMaxFlow(capMatrix,costMatrix,source,sink);
        long maxFlowEnd = Calendar.getInstance().getTimeInMillis();
        System.out.println("Time for Flow Calculation: " + (maxFlowEnd-maxFlowStart) + " ms");
        
        double totalFlow = maxflow[0];
        double totalCost = maxflow[1];
        totalCost = totalCost/costMultiplier;
        
        emd = totalCost/totalFlow;
        
        int numValues = (costMatrix.length-2)/2;
        sourceFlowVector = new int[numValues];
        sinkFlowVector = new int[numValues];
        for(int index = 0; index < numValues; index++){
            sourceFlowVector[index] = nf.flow[source][index];
            sinkFlowVector[index] = nf.flow[index+numValues][sink];
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
    
    public double getEmd() {
        return emd;
    }

    public int[] getSourceFlowVector() {
        return sourceFlowVector;
    }

    public int[] getSinkFlowVector() {
        return sinkFlowVector;
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
