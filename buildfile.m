function plan = buildfile
import matlab.buildtool.tasks.*

plan = buildplan(localfunctions);

% Open project if it is not open
if isempty(matlab.project.rootProject)
    openProject(plan.RootFolder);
end

% Set default task
plan.DefaultTasks = "test";

% Create shorthand for files/folders
codeFiles = fullfile("toolbox","*");
testFiles = fullfile("tests","*");
tbxPackagingFiles = fullfile("utilities","*");
tbxOutputFile = pokerHandsToolboxDefinition().OutputFile;


% Configure tasks
plan("check") = CodeIssuesTask();

plan("test") = TestTask(testFiles, ...
    SourceFiles = codeFiles, ...
    IncludeSubfolders = true,...
    Dependencies = "check");

plan("toolbox").Inputs = [codeFiles,tbxPackagingFiles];
plan("toolbox").Outputs = tbxOutputFile;
plan("toolbox").Dependencies = ["check","test"];

plan("clean") = CleanTask();

end

%% Custom tasks

function toolboxTask(~)
% Package toolbox
packageToolbox();
end