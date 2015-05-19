/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package mincostmaxflowimp;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 *
 * @author Zach
 */
public class DeleteTempFiles {
    
    public static void main(String[] args){
        /*
         * The variable initPath indicates the folder where the MATLAB
         *      text documents are stored and that is where we will
         *      be reading from for this program
         */
        Path curLocation = Paths.get("manifest.mf");
        Path curPath = curLocation.toAbsolutePath();
        Path initPath = curPath.getParent().getParent().getParent().resolve("matricesToCompute");
        
        deleteFilesInDir(initPath);
        
    }
    
    public static void deleteFilesInDir(Path initPath){
        File[] matrixFiles = initPath.toFile().listFiles();
        for(File f:matrixFiles){
            try {
                Files.delete(f.toPath());
            } catch (IOException ex) {
                System.out.println("Cannot delete file " + f.getName());
            }
        }
    }
    
        
        
        
    
}
