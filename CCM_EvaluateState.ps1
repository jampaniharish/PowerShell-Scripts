gwmi -Namespace root\ccm\clientsdk -Class ccm_application -ComputerName LOCALHOST | SELECT NAME, EVALUATIONSTATE, INSTALLSTATE
