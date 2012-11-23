/*******************************************************************************
 * Copyright (c) 2011 Michael Ruflin, Andr� Locher, Claudia von Bastian.
 * 
 * This file is part of Tatool.
 * 
 * Tatool is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published 
 * by the Free Software Foundation, either version 3 of the License, or 
 * (at your option) any later version.
 * 
 * Tatool is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with Tatool. If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package ch.tatool.element;

import ch.tatool.exec.ExecutionContext;

/**
 * A strategy object defines how the next Element is selected.
 * It is invoked before each full execution cycle.
 * 
 * @author Michael Ruflin
 */
public interface ExecutionStrategy {
	
	/**
	 * Update the stack with the next element for execution.
	 * 
	 * @param executionContext
	 * @return true if the stack was successfully updated, false if execution should finish.
	 */
	public boolean updateElementStack(ExecutionContext executionContext);
}
