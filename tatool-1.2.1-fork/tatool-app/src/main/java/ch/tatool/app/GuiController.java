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
package ch.tatool.app;

import java.awt.event.*;
import java.util.*;

import javax.swing.SwingUtilities;

import org.slf4j.*;

import ch.tatool.app.gui.*;
import ch.tatool.app.service.UserAccountService;
import ch.tatool.app.service.exec.ExecutionService;
import ch.tatool.core.module.creator.*;
import ch.tatool.data.*;
import ch.tatool.data.UserAccount.Info;
import ch.tatool.exec.*;
import ch.tatool.module.*;

/**
 * This class acts as the gui and data manager for the Tatool.
 * 
 * It contains the glue code between the different windows to keep one from each
 * other separated and centrally managed.
 * 
 * The controller also manages default module objects to be loaded, but NOT the
 * default account loading (as this is managed outside the account/module data
 * structure.
 * 
 * @author Michael Ruflin
 */
public class GuiController {

	private Logger logger = LoggerFactory.getLogger(GuiController.class);

	// frame keys set in the state maps
	public static final String LOGIN_FRAME = "LoginFrame";
	public static final String MODULE_MANAGER_FRAME = "ModuleManagerFrame";
	public static final String MODULE_OPEN_FRAME = "ModuleOpenFrame";
	public static final String MODULE_OVERVIEW_FRAME = "ModuleOverviewFrame";

	/** Current Account instance. */
	private UserAccount userAccount;

	/** Current module instance. */
	private Module module;

	// Services
	private UserAccountService userAccountService;
	private ModuleService moduleService;
	private ExecutionService executionService;

	// GUI elements
	private LoginFrame loginFrame;
	private ModuleManagerFrame moduleManagerFrame;
	private ModuleOverviewFrame moduleOverviewFrame;

	private FrameVisibilityListener frameVisibilityListener;
	private ModuleExecutorWindowDisplayer moduleExecutionListener;

	/** state variables */
	private boolean enabled;

	private Map<String, Boolean> displayedWindows;
	private Map<String, Boolean> enabledWindows;
	
	// Additional info needed for loading the correct module and for HitC integration
	private int moduleID;
	private String code;
	private String name;

	public GuiController() {
		System.out.println("in gui");
		enabled = false;
		displayedWindows = new HashMap<String, Boolean>();
		enabledWindows = new HashMap<String, Boolean>();
		enabledWindows.put(LOGIN_FRAME, true);
		enabledWindows.put(MODULE_MANAGER_FRAME, true);
		enabledWindows.put(MODULE_OVERVIEW_FRAME, true);
		enabledWindows.put(MODULE_OPEN_FRAME, true);
		displayedWindows.put(LOGIN_FRAME, false);
		displayedWindows.put(MODULE_MANAGER_FRAME, false);
		displayedWindows.put(MODULE_OVERVIEW_FRAME, false);
		displayedWindows.put(MODULE_OPEN_FRAME, false);

		frameVisibilityListener = new FrameVisibilityListener();
		moduleExecutionListener = new ModuleExecutorWindowDisplayer();
	}

	/** Called by spring after all properties have been set. */
	public void init() {
		// add the frame visibility listener to all frames
		loginFrame.addComponentListener(frameVisibilityListener);
		moduleManagerFrame.addComponentListener(frameVisibilityListener);
		moduleOverviewFrame.addComponentListener(frameVisibilityListener);
		executionService.getPhaseListenerManager().addExecutionPhaseListener(moduleExecutionListener, ExecutionPhase.EXECUTION_START);
		executionService.getPhaseListenerManager().addExecutionPhaseListener(moduleExecutionListener, ExecutionPhase.EXECUTION_FINISH);
	}

	public void setModuleID(int moduleID) {
		this.moduleID = moduleID;
	}
	
	public void setCode(String code) {
		this.code = code;
	}
	
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * Enable the controller. If enabled, the controller will react to module
	 * and account changes by adapting the UI accordingly.
	 */
	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	/**
	 * Starts the controller
	 */
	public void startGUI() {
		displayMostSuitableWindow();
	}

	private void displayMostSuitableWindow() {
		System.out.println("in display suitable");
		UserAccountService accountService = getUserAccountService();
		List<Info> accounts = accountService.getAccounts();
		for (Info acc : accounts) {
			if(acc.getName().equals(this.name))
				userAccount = accountService.loadAccount(acc, null);
		}
		if (userAccount == null || !userAccount.getName().equals(this.name))
			userAccount = createAccount();
		
		System.out.println(userAccount.getName());
		
		moduleManagerFrame.initialize(userAccount);
		List<ModuleCreator> creators = moduleManagerFrame.getModuleCreatorRegistry().getCreators();
		for (ModuleCreator mc : creators) {
			if (mc instanceof LocalFileModuleCreator) {
				System.out.println("in local module file creator");
				LocalFileModuleCreator creator = (LocalFileModuleCreator) mc;
				creator.setMessages(moduleManagerFrame.getMessages()); // prevents NPE
				// Pass along the necessary module information
				creator.setModuleID(moduleID);
				creator.setCode(code);
				moduleManagerFrame.openCreator(creator.getCreatorId());
				//displayModuleOverviewFrame();
			}
		}
	}

	// frame hiding

	private void hideModuleManagerFrame() {
		if (displayedWindows.get(MODULE_MANAGER_FRAME)) {
			displayedWindows.put(MODULE_MANAGER_FRAME, false);
			moduleManagerFrame.setVisible(false);
		}
	}

	private void hideModuleOverviewFrame() {
		if (displayedWindows.get(MODULE_OVERVIEW_FRAME)) {
			displayedWindows.put(MODULE_OVERVIEW_FRAME, false);
			moduleOverviewFrame.setVisible(false);
		}
	}

	private void hideLoginFrame() {
		if (displayedWindows.get(LOGIN_FRAME)) {
			displayedWindows.put(LOGIN_FRAME, false);
			loginFrame.setVisible(false);
		}
	}

	// frame displaying

	public void displayModuleOverviewFrame() {
		System.out.println("in displayModuleOverviewFrame");
		System.out.println(module);
		if (userAccount == null || module == null) {
			throw new RuntimeException(
					"Cannot display module overview without account and module");
		}

		// check whether we have a manager frame open, close if that's the case
		hideModuleManagerFrame();
		hideLoginFrame();

		moduleOverviewFrame.initialize(module);
		moduleOverviewFrame.setVisible(true);
		moduleOverviewFrame.toFront();
		displayedWindows.put(MODULE_OVERVIEW_FRAME, true);
	}

	public void displayModuleManagerFrame() {
		if (userAccount == null) {
			throw new RuntimeException(
					"Cannot display module manager without account");
		}

		// hide the user account manager
		hideLoginFrame();

		// check whether we have a module frame currently open - if so,
		// make sure its not active
		if (displayedWindows.get(MODULE_OVERVIEW_FRAME)) {
			// TODO
		}

		moduleManagerFrame.initialize(userAccount);
		moduleManagerFrame.setVisible(true);
		moduleManagerFrame.toFront();
		displayedWindows.put(MODULE_MANAGER_FRAME, true);
	}

	public void displayLoginFrame() {
		loginFrame.initialize();
		loginFrame.setVisible(true);
		loginFrame.toFront();
		displayedWindows.put(LOGIN_FRAME, true);
	}

	// data objects closing

	private void closeCurrentModule() {
		if (this.module != null) {
			// close the module window if it is displayed currently
			hideModuleOverviewFrame();

			// close the module
			moduleService.closeModule(this.module);
			this.module = null;
		}
	}

	private void closeCurrentAccount() {
		if (this.userAccount != null) {
			// close the previous user account
			userAccountService.closeAccount(this.userAccount);
			this.userAccount = null;
		}
	}

	// data object setting/setup

	public void setModule(final Module module) {
		// close the module if one is present
		// as this will involve closing the window
		//closeCurrentModule();

		// assign the new module
		this.module = module;

		// if enabled, display the window. Postpone this until all AWT events
		// have been processed,
		// which includes the window closing event possibly triggered by
		// closeCurrentModule
		if (enabled) {
			SwingUtilities.invokeLater(new Runnable() {
				public void run() {
					displayModuleOverviewFrame();
				}
			});
		}
	}

	public void setUserAccount(final UserAccount userAccount) {
		// close the current module and account
		closeCurrentModule();
		closeCurrentAccount();
		this.userAccount = userAccount;

		// display the appropriate window, but postpone this until all AWT
		// events have been processed
		if (enabled) {
			SwingUtilities.invokeLater(new Runnable() {
				public void run() {
					if (userAccount != null) {
						checkAccountPreferences();
					}
					displayMostSuitableWindow();
				}
			});
		}
	}

	/**
	 * Accounts can have a default module set, or defined that no module
	 * selection/management is allowed
	 */
	private void checkAccountPreferences() {
		checkLoadLastOpenedAccount();
		checkDisableModuleManager();
	}

	/** Check whether the last opened account should be loaded. */
	private void checkLoadLastOpenedAccount() {
		// check whether we should automatically load the last opened module
		if (!(userAccount.getProperties().containsKey(
				Constants.PROPERTY_OPEN_LAST_LOADED_MODULE) && (Boolean
				.parseBoolean(userAccount.getProperties().get(
						Constants.PROPERTY_OPEN_LAST_LOADED_MODULE))))) {
			return;
		}

		// try to get the id of the module to load
		String defaultModuleId = userAccount.getProperties().get(
				Constants.PROPERTY_LAST_LOADED_MODULE_ID);
		if (defaultModuleId == null) {
			return;
		}

		// find a module info object with given id
		Module.Info tInfo = null;
		for (Module.Info i : moduleService.getModules(userAccount)) {
			if (i.getId().toString().equals(defaultModuleId)) {
				tInfo = i;
				break;
			}
		}
		// load the module if we have a module info object
		if (tInfo != null) {
			Module module = moduleService.loadModule(tInfo);
			// bypass the setter here
			this.module = module;
		}
	}

	/** Check whether the module manager should be disabled. */
	private void checkDisableModuleManager() {
		String value = userAccount.getProperties().get(
				Constants.DISABLE_MODULE_MANAGEMENT);
		boolean moduleManagerDisabled = (value != null && Boolean
				.parseBoolean(value));
		if (!moduleManagerDisabled) {
			moduleOverviewFrame.setModuleManagementEnabled(true);
			return;
		}

		// disable module management
		moduleOverviewFrame.setModuleManagementEnabled(false);

		// check whether we already got a module (hardly possible,
		// but use that module in such a case)
		if (this.module != null) {
			return;
		}

		// load the first module available in the account
		Set<Module.Info> infos = moduleService.getModules(userAccount);
		if (infos.size() < 1) {
			// this should never happen - it means we have an account without
			// module but that does not allow a module creation
			throw new RuntimeException(
					"Invalid user account - module management disabled but no modules available!");
		}

		Module.Info tInfo = infos.iterator().next();
		Module module = moduleService.loadModule(tInfo);
		// bypass the setter here
		this.module = module;
	}

	void loginClosed() {
		if (displayedWindows.get(LOGIN_FRAME)) {
			displayedWindows.put(LOGIN_FRAME, false);
			checkProgramExit();
		}
	}

	void moduleManagerClosed() {
		if (displayedWindows.get(MODULE_MANAGER_FRAME)) {
			displayedWindows.put(MODULE_MANAGER_FRAME, false);
			checkProgramExit();
		}
	}
	
	void openDetailClosed() {
		if (displayedWindows.get(MODULE_OPEN_FRAME)) {
			displayedWindows.put(MODULE_OPEN_FRAME, false);
			checkProgramExit();
		}
	}

	void moduleOverviewClosed() {
		if (displayedWindows.get(MODULE_OVERVIEW_FRAME)) {
			displayedWindows.put(MODULE_OVERVIEW_FRAME, false);
			checkProgramExit();
		}
	}

	void checkProgramExit() {
		boolean open = false;
		for (Boolean b : displayedWindows.values()) {
			open = open || b;
		}
		if (!open) {
			// cleanup
			shutdown();
		}
	}

	public void shutdown() {
		logger.info("Shutting down...");
		closeCurrentModule();
		closeCurrentAccount();
		System.exit(0);
	}

	// event listeners

	class FrameVisibilityListener extends ComponentAdapter {

		@Override
		public void componentHidden(ComponentEvent e) {
			if (e.getSource() == moduleOverviewFrame) {
				moduleOverviewClosed();
			} else if (e.getSource() == moduleManagerFrame) {
				moduleManagerClosed();
			} else if (e.getSource() == loginFrame) {
				loginClosed();
			}
		}

	}

	// Module Listener

	class ModuleExecutorWindowDisplayer implements ExecutionPhaseListener {

		public void processExecutionPhase(ExecutionContext context) {
			switch (context.getPhase()) {
			case EXECUTION_FINISH:
				moduleFinished();
				 break;
			default:
				break;
			}
		}

		private void moduleFinished() {
			checkProgramExit();
		}
	}

	// Setters and getters

	public UserAccount getUserAccount() {
		return userAccount;
	}

	public Module getModule() {
		return module;
	}

	public LoginFrame getLoginFrame() {
		return loginFrame;
	}

	public void setLoginFrame(LoginFrame loginFrame) {
		this.loginFrame = loginFrame;
	}

	public ModuleOverviewFrame getModuleOverviewFrame() {
		return moduleOverviewFrame;
	}

	public void setModuleOverviewFrame(
			ModuleOverviewFrame moduleOverviewFrame) {
		this.moduleOverviewFrame = moduleOverviewFrame;
	}

	public UserAccountService getUserAccountService() {
		return userAccountService;
	}

	public void setUserAccountService(UserAccountService userAccountService) {
		this.userAccountService = userAccountService;
	}

	public ModuleService getModuleService() {
		return moduleService;
	}

	public void setModuleService(ModuleService moduleService) {
		this.moduleService = moduleService;
	}

	public ExecutionService getExecutionService() {
		return executionService;
	}

	public void setExecutionService(
			ExecutionService executionService) {
		this.executionService = executionService;
	}

	public ModuleManagerFrame getModuleManagerFrame() {
		return moduleManagerFrame;
	}

	public void setModuleManagerFrame(
			ModuleManagerFrame moduleManagerFrame) {
		this.moduleManagerFrame = moduleManagerFrame;
	}
	
	/**
     * Creates and initializes a user account.
     * @return a newly created user account
     */
    protected UserAccount createAccount() {
        // create a test user account
        return getUserAccountService().createAccount(name, createAccountProperties(), null);   
    }
    
    /** Get the Account properties to use for account creation. */
    protected Map<String, String> createAccountProperties() {
    	Map<String, String> accountProperties = new HashMap<String, String>();
    	return accountProperties;
    }
}
