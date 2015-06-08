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

import com.joptimizer.functions.ConvexMultivariateRealFunction;
import com.joptimizer.functions.LinearMultivariateRealFunction;
import com.joptimizer.functions.PDQuadraticMultivariateRealFunction;
import com.joptimizer.optimizers.JOptimizer;
import com.joptimizer.optimizers.OptimizationRequest;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Zach
 */
public class TestImp {
    
    static final Path curLocation = Paths.get("manifest.mf");
    static final Path curPath = curLocation.toAbsolutePath();
    static final Path initPath = curPath.getParent().getParent().getParent();
    static final Path inputPath = initPath.resolve("matricesToCompute");
    
    public static void main(String[] args){
        
        
        double[][] sample = new double[10100][10100];
        
        
        // Objective function
        double[][] P = new double[][] {{ 1., 0.4 }, { 0.4, 1. }};
        PDQuadraticMultivariateRealFunction objectiveFunction = new PDQuadraticMultivariateRealFunction(P, null, 0);

        //equalities
        double[][] A = new double[][]{{1,1}};
        double[] b = new double[]{1};

        //inequalities
        ConvexMultivariateRealFunction[] inequalities = new ConvexMultivariateRealFunction[2];
        inequalities[0] = new LinearMultivariateRealFunction(new double[]{-1, 0}, 0);
        inequalities[1] = new LinearMultivariateRealFunction(new double[]{0, -1}, 0);

        //optimization problem
        OptimizationRequest or = new OptimizationRequest();
        or.setF0(objectiveFunction);
        or.setInitialPoint(new double[] { 0.1, 0.9});
        //or.setFi(inequalities); //if you want x>0 and y>0
        or.setA(A);
        or.setB(b);
        or.setToleranceFeas(1.E-12);
        or.setTolerance(1.E-12);

        //optimization
        JOptimizer opt = new JOptimizer();
        opt.setOptimizationRequest(or);
        int returnCode = 0;
        try {
            returnCode = opt.optimize();
        } catch (Exception ex) {
            System.out.println(ex);
        }
        
        double[] sol = opt.getOptimizationResponse().getSolution();
        		
        
        System.out.println("Return Code: " + returnCode);
        System.out.println("Sol 0: " + sol[0]);
        System.out.println("Sol 1: " + sol[1]);
        
    }
    
    
    
}
