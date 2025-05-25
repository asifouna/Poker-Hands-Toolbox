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
testResultsFile = fullfile("results","TestResults.html");
coverageResultsFile = fullfile("results","CoverageResults.html");


% CodeIssues task
plan("check") = CodeIssuesTask();

% Test task
tTask = TestTask(testFiles, ...
    SourceFiles = codeFiles, ...
    IncludeSubfolders = true,...
    TestResults = testResultsFile, ...
    Dependencies = "check");
tTask = tTask.addCodeCoverage(coverageResultsFile, ...
    MetricLevel = "mcdc");
plan("test") = tTask;

% Custom "toolbox" task
plan("toolbox").Inputs = [codeFiles,tbxPackagingFiles];
plan("toolbox").Outputs = tbxOutputFile;
plan("toolbox").Dependencies = ["check","test"];

% Clean task
plan("clean") = CleanTask();

end

%% Custom tasks

function toolboxTask(~)
% Package toolbox
packageToolbox();
end