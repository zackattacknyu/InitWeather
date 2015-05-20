/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package mincostmaxflowimp;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileAlreadyExistsException;
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
    
    /*
    * The variable initPath indicates the folder where the MATLAB
    *      text documents are stored and that is where we will
    *      be reading from for this program
    */
   static final Path curLocation = Paths.get("manifest.mf");
   static final Path curPath = curLocation.toAbsolutePath();
   static final Path initPath = curPath.getParent().getParent().getParent();
   static final Path inputPath = initPath.resolve("matricesToCompute");
   static final Path outputPath = initPath.resolve("emdResults");

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException {
        try{
            Files.createDirectory(outputPath);
        }catch(FileAlreadyExistsException e){}
        

        //just the name of the file, folder is sorted out below
        String costMatrixFileName;
        String capMatrixFileName;
        Path costMatrixFile;
        Path capMatrixFile;
        
        String sourceFlowVectorFileName;
        String sinkFlowVectorFileName;
        Path sourceFlowVectorFile;
        Path sinkFlowVectorFile;
        
        String pixelFlowMatrixFileName;
        Path pixelFlowMatrixFile;
        
        int docNum = 1;

        ArrayList<String> emdResults = new ArrayList<String>(100);
        double currentEMD;
        EmdResults currentResults;
        
        DeleteTempFiles.deleteFilesInDir(outputPath);
        
        while(true){
            costMatrixFileName = "costMatrix" + docNum + ".txt";
            capMatrixFileName = "capMatrix" + docNum + ".txt";
            
            sourceFlowVectorFileName = "sourceFlow" + docNum + ".txt";
            sinkFlowVectorFileName = "sinkFlow" + docNum + ".txt";
            
            pixelFlowMatrixFileName = "pixelFlowMatrix" + docNum + ".txt";
            
            //gets the file paths we need
            costMatrixFile = inputPath.resolve(costMatrixFileName);
            capMatrixFile = inputPath.resolve(capMatrixFileName);
            
            //gets output file paths
            sourceFlowVectorFile = outputPath.resolve(sourceFlowVectorFileName);
            sinkFlowVectorFile = outputPath.resolve(sinkFlowVectorFileName);
            pixelFlowMatrixFile = outputPath.resolve(pixelFlowMatrixFileName);
            
            if(!costMatrixFile.toFile().exists() || !capMatrixFile.toFile().exists()){
                break;
            }
            
            currentResults = new EmdResults(costMatrixFile,capMatrixFile);
            currentEMD = currentResults.getEmd();
            emdResults.add(Double.toString(currentEMD));
            System.out.println("EMD = " + currentEMD);
            
            writeTextFile(sourceFlowVectorFile,
                    makeLinesFromArray(currentResults.getSourceFlowVector()));
            writeTextFile(sinkFlowVectorFile,
                    makeLinesFromArray(currentResults.getSinkFlowVector()));
            writeTextFile(pixelFlowMatrixFile,
                    makeLinesFromMatrix(currentResults.getPixelFlowMatrix()));
            
            docNum++;
        }
        
        Path emdResultFile = outputPath.resolve("allEMDvalues.txt");
        writeTextFile(emdResultFile,emdResults);

    }
    
    public static ArrayList<String> makeLinesFromMatrix(int[][] matrix){
        ArrayList<String> lines = new ArrayList<String>();
        StringBuilder curString;
        for(int i = 0; i < matrix.length; i++){
            curString = new StringBuilder();
            for(int j = 0; j < matrix[0].length; j++){
                curString.append(matrix[i][j]);
                curString.append(",");
            }
            curString.deleteCharAt(curString.length()-1); //deletes last comma
            lines.add(curString.toString());
        }
        return lines;
    }
    
    public static ArrayList<String> makeLinesFromArray(int[] array){
        ArrayList<String> lines = new ArrayList<String>();
        for(int val:array){
            lines.add(Integer.toString(val));
        }
        return lines;
    }
    
    public static void writeTextFile(Path file, ArrayList<String> lines){
        try {
            Files.write(file, lines, StandardCharsets.UTF_8);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
    
    
    
}
