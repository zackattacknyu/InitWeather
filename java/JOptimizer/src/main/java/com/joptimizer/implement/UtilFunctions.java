/*
 * Copyright 2015 JOptimizer.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.joptimizer.implement;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;

/**
 *
 * @author Zach
 */
public class UtilFunctions {
    
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
