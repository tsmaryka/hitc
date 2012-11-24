/*******************************************************************************
 * Copyright (c) 2011 Michael Ruflin, André Locher, Claudia von Bastian.
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
package ch.tatool.app.gui;

import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.util.Set;

import javax.swing.DefaultListModel;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPopupMenu;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.tatool.app.Constants;
import ch.tatool.app.GuiController;
import ch.tatool.app.service.UserAccountService;
import ch.tatool.data.Messages;
import ch.tatool.data.Module;
import ch.tatool.data.UserAccount;
import ch.tatool.module.ModuleCreator;
import ch.tatool.module.ModuleCreatorRegistry;
import ch.tatool.module.ModuleService;

/**
 * Dialog allowing to open an existing module or to create a new module
 * using one of the registered ModuleConfigurators
 * 
 * @author Michael Ruflin
 */
public class ModuleManagerFrame extends javax.swing.JFrame {
    
    Logger logger = LoggerFactory.getLogger(ModuleManagerFrame.class);
    
    public static final String DEFAULT_MODULE_ID = "default.module.id"; //$NON-NLS-1$
    
    private static final long serialVersionUID = -4668990416882096902L;
    
    /** IoC */
    private UserAccountService userAccountService;
    private ModuleService moduleService;
    private ModuleCreatorRegistry moduleCreatorRegistry;
    private GuiController guiController;
    
    /** Holds the list elements. */
    private DefaultListModel listModel;
    
    /** UserAccount for which to display modules. */
    private UserAccount account;
    
    /** Currently active module creator. */
    private ModuleCreator currentCreator;

	private Messages messages;
  
    public ModuleManagerFrame() {
    	logger.info("Create new instance of ModuleManagerFrame"); //$NON-NLS-1$
    }
    
    public void init() {
        listModel = new DefaultListModel();
    }
    
    /**
     * Initialize the manager.
     */
    public void initialize(UserAccount account) {
        this.account = account;
        
        initComponents();
        getRootPane().setDefaultButton(openTrainingButton);
        //TODO: Allow deleting
        //deleteTrainingButton.setVisible(false);
        
        initData();
        pack();
        setLocationRelativeTo(null);
        java.net.URL iconUrl = this.getClass().getResource("/ch/tatool/app/gui/icon.png"); //$NON-NLS-1$
		Image icon = getToolkit().getImage(iconUrl); 
		setIconImage(icon);
    }
    
	/** Initializes the frame with data. */
	public void initData() {
	    // fill the model with the current set of available module instances 
	    listModel.removeAllElements();
		//Set<Module.Info> modules = moduleService.getModules(account);
		//for (Module.Info t : modules) {
		//    listModel.addElement(t);
		//}
		moduleList.setSelectedIndex(0);

		// only enable module creation button if we have registered creators
		selectCreatorButton.setEnabled(! moduleCreatorRegistry.getCreators().isEmpty());
	}   

	/** Deletes the selected module. */
    private void deleteModule() {
        // get the selected module
        Module.Info moduleInfo = (Module.Info) moduleList.getSelectedValue();
        if (moduleInfo == null) {
            return;
        }
            
        // make sure the user knows what he/she is doing
        Object[] options = { messages.getString("General.okLabel"), messages.getString("General.cancelLabel") }; //$NON-NLS-1$ //$NON-NLS-2$
        int result = JOptionPane.showOptionDialog(
                this, messages.getString("ModuleManagerFrame.label.confirmDelete") + " '" +  moduleInfo.toString() + "'", //$NON-NLS-1$ //$NON-NLS-2$
                messages.getString("General.errorMessage.windowTitle.warning"), JOptionPane.DEFAULT_OPTION, JOptionPane.WARNING_MESSAGE, //$NON-NLS-1$
                null, options, options[0]);
        
        // continue if the user chose ok
        if (result == JOptionPane.OK_OPTION) {
            moduleService.deleteModule(moduleInfo);
            
            // refresh ui
            initData();
        }
    }

    /** Opens the selected module. */
    private void openSelectedModule() {
        // get the selected module
        Module.Info moduleInfo = (Module.Info) moduleList.getSelectedValue();
        if (moduleInfo == null) {
            return;
        }
        
        // load the module
        Module module = moduleService.loadModule(moduleInfo);
        openModule(module);
    }
    
    /** Opens a module. */
    private void openModule(Module module) {
        // update the account with information regarding the last opened module and whether the module should be loaded automatically
        account.getProperties().put(Constants.PROPERTY_LAST_LOADED_MODULE_ID, module.getId().toString());
        userAccountService.saveAccount(account);
        
        // now let the gui controller open the module
        guiController.setModule(module);
    }

    /**
     * Displays a menu with the available creators.
     */
    private void showCreatorMenu() {
    	// create a listener for actionevents
    	ActionListener menuReactor = new ActionListener() {
            public void actionPerformed(ActionEvent evt) {
            	JMenuItem source = (JMenuItem) evt.getSource();
                openCreator(source.getActionCommand());
            }
        };
    
    	JPopupMenu creatorPopupMenu;
    	creatorPopupMenu = new JPopupMenu();
    	for (ModuleCreator creator : moduleCreatorRegistry.getCreators()) {
    		creator.setMessages(messages);
    		JMenuItem item = new JMenuItem(creator.getCreatorName());
    		item.setActionCommand(creator.getCreatorId());
    		item.addActionListener(menuReactor);
    		creatorPopupMenu.add(item);
    	}
    	creatorPopupMenu.pack();
    	creatorPopupMenu.show(selectCreatorButton, 0, selectCreatorButton.getHeight());
    }
    
    // Changed to public so that it can be accessed from GuiController
    public void openCreator(String creatorId) {
    	if (currentCreator != null) {
    		currentCreator.hideCreator();
    		currentCreator = null;
    	}
    	
    	// get the creator with the given id
    	currentCreator = moduleCreatorRegistry.getCreatorById(creatorId);
    	if (currentCreator == null) {
    		return;
    	}
    	
    	ModuleCreator.Callback callback = new ModuleCreator.Callback() {
    		public void closeDialog(Module newlyCreatedModule) {
    			currentCreator.hideCreator();
    			currentCreator = null;
    			if (newlyCreatedModule != null) {
    				openModule(newlyCreatedModule);
    			}
    		}
    	};
    	try {
    		currentCreator.executeCreator(this, account, moduleService, callback);
    	} catch (IOException e) {
    		
    	}
    }
    
    public void setVisible(boolean visible) {
    	if (currentCreator != null) {
    		currentCreator.hideCreator();
    		currentCreator = null;
    	}
    	super.setVisible(visible);
    }
    
    
    // Getters and setters
    public ModuleService getModuleService() {
        return moduleService;
    }

    public void setModuleService(ModuleService moduleService) {
        this.moduleService = moduleService;
    }
    
    public GuiController getGuiController() {
        return guiController;
    }

    public void setGuiController(GuiController guiController) {
        this.guiController = guiController;
    }

    public UserAccount getAccount() {
        return account;
    }

    public void setAccount(UserAccount account) {
        this.account = account;
    }

    public UserAccountService getUserAccountService() {
        return userAccountService;
    }

    public void setUserAccountService(UserAccountService userAccountService) {
        this.userAccountService = userAccountService;
    }

    public ModuleCreatorRegistry getModuleCreatorRegistry() {
		return moduleCreatorRegistry;
	}

	public void setModuleCreatorRegistry(
			ModuleCreatorRegistry moduleCreatorRegistry) {
		this.moduleCreatorRegistry = moduleCreatorRegistry;
	}
	
	public void setMessages(Messages messages) {
    	this.messages = messages;
    }
    
    public Messages getMessages() {
		return messages;
	}

	/**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    //@SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {
    	getContentPane().removeAll();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        moduleList = new javax.swing.JList();
        openTrainingButton = new javax.swing.JButton();
        selectCreatorButton = new javax.swing.JButton();
        deleteTrainingButton = new javax.swing.JButton();

        setTitle(messages.getString("General.title")); //$NON-NLS-1$
        setResizable(false);

        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder(null, messages.getString("ModuleManagerFrame.labelTitle.myModules"), javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14))); // NOI18N //$NON-NLS-1$ //$NON-NLS-2$

        moduleList.setFont(moduleList.getFont().deriveFont(moduleList.getFont().getSize()+3f));
        moduleList.setModel(listModel);
        moduleList.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        moduleList.setVisibleRowCount(10);
        moduleList.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                moduleListMouseClicked(evt);
            }
        });
        jScrollPane1.setViewportView(moduleList);

        openTrainingButton.setText(messages.getString("ModuleManagerFrame.label.openModule")); //$NON-NLS-1$
        openTrainingButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                openTrainingButtonActionPerformed(evt);
            }
        });

        selectCreatorButton.setText(messages.getString("ModuleManagerFrame.label.addModule")); //$NON-NLS-1$
        selectCreatorButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                selectCreatorButtonActionPerformed(evt);
            }
        });

        deleteTrainingButton.setText(messages.getString("ModuleManagerFrame.label.deleteModule")); //$NON-NLS-1$
        deleteTrainingButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                deleteTrainingButtonActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 274, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel2Layout.createSequentialGroup()
                        .addComponent(selectCreatorButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(deleteTrainingButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 43, Short.MAX_VALUE)
                        .addComponent(openTrainingButton)))
                .addContainerGap())
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 143, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(selectCreatorButton)
                    .addComponent(deleteTrainingButton)
                    .addComponent(openTrainingButton))
                .addContainerGap())
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void selectCreatorButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_selectCreatorButtonActionPerformed
    	showCreatorMenu();
    	//createTraining();
    }//GEN-LAST:event_selectCreatorButtonActionPerformed

    private void deleteTrainingButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_deleteTrainingButtonActionPerformed
        deleteModule();
    }//GEN-LAST:event_deleteTrainingButtonActionPerformed

    private void moduleListMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_moduleListMouseClicked
        if (evt.getClickCount() > 1) {
            openSelectedModule();
        }
    }//GEN-LAST:event_moduleListMouseClicked

	private void openTrainingButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_openTrainingButtonActionPerformed
		openSelectedModule();
	}//GEN-LAST:event_openTrainingButtonActionPerformed

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton deleteTrainingButton;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JList moduleList;
    private javax.swing.JButton openTrainingButton;
    private javax.swing.JButton selectCreatorButton;
    // End of variables declaration//GEN-END:variables

}
