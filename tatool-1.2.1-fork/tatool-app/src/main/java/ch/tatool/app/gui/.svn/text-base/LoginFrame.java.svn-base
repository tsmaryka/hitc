/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * LoginFrame.java
 *
 * Created on 02.08.2009, 17:20:04
 */
package ch.tatool.app.gui;

import java.awt.Component;
import java.awt.Dimension;
import java.awt.Image;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.*;

import javax.swing.DefaultComboBoxModel;
import javax.swing.JOptionPane;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.tatool.app.*;
import ch.tatool.app.service.UserAccountException;
import ch.tatool.app.service.UserAccountService;
import ch.tatool.data.Messages;
import ch.tatool.data.UserAccount;

/** Login Frame implementation.
 * 
 * Allows a user to create a new account or choose an existing account from a drop down.
 * 
 * @author Andre Locher
 */
public class LoginFrame extends javax.swing.JFrame {

	private static final long serialVersionUID = -8756830160634444342L;

	private static Logger logger = LoggerFactory.getLogger(LoginFrame.class);

	/** UserAccountService - provides data for this frame. */
	private UserAccountService userAccountService;

	/** GuiController. */
	private GuiController guiController;

	private DefaultComboBoxModel userComboBoxModel = new DefaultComboBoxModel();;

	//private CreateAccountFrame createAccountFrame;

	private Messages messages;

	public LoginFrame() {
		logger.info("Create new instance of LoginFrame");
	}
	
	public void init() {
		initComponents();
		getRootPane().setDefaultButton(loginButton);
	}

	/**
	 * Called before the window is displayed
	 */
	public void initialize() {
		initData();
		pack();
		Dimension size = getSize();
		size.height += 20;
		setSize(size);
		setLocationRelativeTo(null);
		java.net.URL iconUrl = this.getClass().getResource("/ch/tatool/app/gui/icon.png"); //$NON-NLS-1$
		Image icon = getToolkit().getImage(iconUrl); 
		setIconImage(icon);
		
		if (userAccountService.getAccounts().isEmpty()) {
			createAccount();
		} else {
			UserAccount account = loadAccount(userAccountService, userAccountService.getAccounts().get(0), this);
			this.openAccount(account);
		}
	}

	public void createAccount() {
		// For our purposes, we only want a single user account. If there's already one present, don't create another one!
		if (!userAccountService.getAccounts().isEmpty()) {
			return;
		}
		
        HashMap<String, String> accountProperties = new HashMap<String, String>();
        
        // Set account language 
        // TODO we probably need to set this dynamically (another command-line arg needed?)
        accountProperties.put(Constants.PROPERTY_ACCOUNT_LANG, "en");
        
        // add machine properties 
        // TODO do we really need this?
        accountProperties.put(Constants.PROPERTY_MACHINE_OS_NAME, System.getProperty("os.name")); //$NON-NLS-1$
        accountProperties.put(Constants.PROPERTY_MACHINE_OS_ARCH, System.getProperty("os.arch")); //$NON-NLS-1$
        accountProperties.put(Constants.PROPERTY_MACHINE_OS_VERSION, System.getProperty("os.version")); //$NON-NLS-1$
        accountProperties.put(Constants.PROPERTY_MACHINE_USER_HOME, System.getProperty("user.home")); //$NON-NLS-1$

        // Note: account should not be null--the method below returns null only when there's another account with the same name
        // But we shouldn't even be here if there was already an existing account in the first place!
        UserAccount account = userAccountService.createAccount("", accountProperties, null);
        this.openAccount(account);
	}

	public void loginAccount() {
		UserAccount account = null;

		// fetch the info object
		UserAccount.Info info = (UserAccount.Info) userComboBoxModel
				.getSelectedItem();
		if (info != null) {
			account = loadAccount(userAccountService, info, this);
		}
		// open the account
		if (account != null) {
			openAccount(account);
		}
	}

	public void openAccount(UserAccount account) {	
		// display the training loader frame
		guiController.setUserAccount(account);
	}
	
	/** Overridden to also hide the user account frame if open. */
//	public void setVisible(boolean visible) {
//		// check whether we have an CreateAccountFrame open
//		if ( !visible && createAccountFrame != null && createAccountFrame.isVisible()) {
//			createAccountFrame.dispose();
//			createAccountFrame = null;
//		}
//		super.setVisible(visible);
//	}

	/**
	 * Opens a UserAccount object by asking the user for a password if
	 * necessary.
	 * 
	 * @param info
	 *            the info object of the account
	 * @return a loaded UserAccount object or null in case an error occured/the
	 *         user aborded entering a password
	 */
	public UserAccount loadAccount(UserAccountService userAccountService,
			UserAccount.Info info, Component parent) {
		// check whether it is password protected
		String password = null;
		//TODO: why is info.isPasswordProtected() not always set?
		//password = getPassword();
		// load the training
		try {
			UserAccount account = userAccountService
					.loadAccount(info, password);
			return account;
		} catch (RuntimeException e) {
			// TODO: following code is database specific and error prone, as
			// we directly check the error message thrown!
			boolean isAccessDeniedException = false;
			Throwable tmp = e;

			while (tmp != null) {
				// hsqldb error
				if (tmp.getMessage().equals("Login failed.")) { //$NON-NLS-1$
					isAccessDeniedException = true;
					break;
				}
				// derby error
				if (tmp.getMessage().trim().equals("Startup failed. An encrypted database cannot be accessed without the correct boot password.")) { //$NON-NLS-1$
					isAccessDeniedException = true;
					break;
				}
				tmp = tmp.getCause();
			}

			if (isAccessDeniedException) {
				JOptionPane
						.showMessageDialog(
								parent,
								messages.getString("LoginFrame.errorMessage.wrongPassword"), messages.getString("General.errorMessage.windowTitle.warning"), JOptionPane.WARNING_MESSAGE); //$NON-NLS-1$ //$NON-NLS-2$
				return null;
			} else {
				// unknown problem
				logger.error("unable to open account", e); //$NON-NLS-1$
				JOptionPane
				.showMessageDialog(
						parent,
						messages.getString("LoginFrame.errorMessage.unknownProblem"), messages.getString("General.errorMessage.windowTitle.warning"), JOptionPane.ERROR_MESSAGE); //$NON-NLS-1$ //$NON-NLS-2$
				writeToFile("tatool.log", getStackTrace(e)); //$NON-NLS-1$
				throw new UserAccountException(e.getMessage(), e);
			}
		}
	}
	
	public static String getStackTrace(Throwable aThrowable) {
        final Writer result = new StringWriter();
        final PrintWriter printWriter = new PrintWriter(result);
        aThrowable.printStackTrace(printWriter);
        return result.toString();
    }
	
	 public void writeToFile(String filename, String output) {
	        
	        BufferedWriter bufferedWriter = null;	        
	        try {
	            
	            //Construct the BufferedWriter object
	        	String userHome = System.getProperty("user.home"); //$NON-NLS-1$
	        	String sep = System.getProperty("file.separator"); //$NON-NLS-1$
	            bufferedWriter = new BufferedWriter(new FileWriter(userHome + sep + filename));
	            bufferedWriter.write(output);
	            
	        } catch (FileNotFoundException ex) {
	            ex.printStackTrace();
	        } catch (IOException ex) {
	            ex.printStackTrace();
	        } finally {
	            //Close the BufferedWriter
	            try {
	                if (bufferedWriter != null) {
	                    bufferedWriter.flush();
	                    bufferedWriter.close();
	                }
	            } catch (IOException ex) {
	                ex.printStackTrace();
	            }
	        }
	    }

	private void initData() {
		userComboBoxModel.removeAllElements();
		// fill the list with the current set of available accounts
		List<UserAccount.Info> accounts = userAccountService.getAccounts();
		for (UserAccount.Info a : accounts) {
			userComboBoxModel.addElement(a);
		}
	}
/*
	public String getPassword() {
		String password = null;
		char[] passwordChar = passwordText.getPassword();
		password = String.valueOf(passwordChar);
		return password;
	}*/

	// Getters and setters
	public UserAccountService getUserAccountService() {
		return userAccountService;
	}

	public void setUserAccountService(UserAccountService userAccountService) {
		this.userAccountService = userAccountService;
	}

	public GuiController getGuiController() {
		return guiController;
	}

	public void setGuiController(GuiController guiController) {
		this.guiController = guiController;
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
	private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        loginButton = new javax.swing.JButton();
        usernameComboBox = new javax.swing.JComboBox();
        newAccountButton = new javax.swing.JButton();

        setTitle(messages.getString("General.title")); //$NON-NLS-1$
        setMinimumSize(new java.awt.Dimension(340, 135));
        setResizable(false);

        jPanel1.setPreferredSize(new java.awt.Dimension(200, 142));

        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/ch/tatool/app/gui/UserGroup.png"))); // NOI18N //$NON-NLS-1$

        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder(null, messages.getString("LoginFrame.labelTitle.user"), javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14))); // NOI18N //$NON-NLS-1$ //$NON-NLS-2$

        loginButton.setText(messages.getString("General.okLabel")); //$NON-NLS-1$
        loginButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                loginButtonActionPerformed(evt);
            }
        });

        usernameComboBox.setFont(new java.awt.Font("Tahoma", 1, 14)); //$NON-NLS-1$
        usernameComboBox.setModel(userComboBoxModel);
        usernameComboBox.setMinimumSize(new java.awt.Dimension(15, 18));
        usernameComboBox.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                usernameComboBoxActionPerformed(evt);
            }
        });

        newAccountButton.setText(messages.getString("LoginFrame.label.createUser")); //$NON-NLS-1$
        newAccountButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                newAccountButtonActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(usernameComboBox, 0, 206, Short.MAX_VALUE)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(newAccountButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(loginButton)))
                .addContainerGap())
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(usernameComboBox, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(loginButton)
                    .addComponent(newAccountButton))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 116, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(12, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, 340, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

	private void newAccountButtonActionPerformed(java.awt.event.ActionEvent evt) {// GEN-FIRST:event_newAccountButtonActionPerformed
		createAccount();
	}// GEN-LAST:event_newAccountButtonActionPerformed

	private void loginButtonActionPerformed(java.awt.event.ActionEvent evt) {// GEN-FIRST:event_loginButtonActionPerformed
		loginAccount();
	}// GEN-LAST:event_loginButtonActionPerformed

	private void usernameComboBoxActionPerformed(java.awt.event.ActionEvent evt) {// GEN-FIRST:event_usernameComboBoxActionPerformed
		// TODO add your handling code here:
	}// GEN-LAST:event_usernameComboBoxActionPerformed

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JButton loginButton;
    private javax.swing.JButton newAccountButton;
    private javax.swing.JComboBox usernameComboBox;
    // End of variables declaration//GEN-END:variables
}
