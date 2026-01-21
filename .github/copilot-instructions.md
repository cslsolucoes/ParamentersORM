# Copilot Instructions - Parameters CSL

**Project:** Parameters v1.0.3 - Multi-source Configuration Management System  
**Language:** Free Pascal (FPC 3.2.2+) / Delphi 10.3+  
**Status:** ~99% Complete - Production Ready  

## Architecture Overview

**Parameters** is a unified configuration parameter management system supporting three data sources: **Database**, **INI Files**, and **JSON Objects** with automatic cascading fallback.

### Public Interface (2 files only)
- **`Parameters.pas`** - Factory methods, main implementation (`TParametersImpl`)
- **`Parameters.Interfaces.pas`** - Exports all public interfaces and re-exported types

### Internal Modules (organized in subdirectories)
- **`Commons/`** - `Types.pas`, `Consts.pas`, `Exceptions.pas` (9 exception types, 90+ error codes)
- **`Database/`** - `Parameters.Database.pas` (4,912 lines, 14 thread-safe methods)
- **`IniFiles/`** - `Parameters.Inifiles.pas` (1,476 lines)
- **`JsonObject/`** - `Parameters.JsonObject.pas` (2,264 lines)
- **`Attributes/`** - RTTI-based declarative mapping (v2.0+ feature, not production yet)

### Data Flow
```
Application Code
    ↓
IParameters (unified interface)
    ├→ IParametersDatabase (primary)
    ├→ IParametersInifiles (secondary - fallback)
    └→ IParametersJsonObject (tertiary - fallback)
```

## Key Patterns & Conventions

### 1. Encapsulation
- **Only expose** `Parameters.pas` and `Parameters.Interfaces.pas` to external code
- All implementation details (Database, Inifiles, JsonObject) are `implementation`-only
- Types and constants re-exported via `Parameters.Interfaces.pas`
- **Pattern:** Factory methods in `Parameters.pas` create instances; callers use only interface references

### 2. Thread-Safety (100% Implementation)
- **All CRUD operations** protected with `TCriticalSection` in `TParametersImpl`
- **Database operations** protected: `List`, `Get`, `Insert`, `Update`, `Delete`, `Exists`, `Count`, `Connect`, `Disconnect`, `Refresh`, `CreateTable`, `DropTable`
- **IniFiles/JsonObject** fully thread-safe
- Use synchronous operations only; no async support by design

### 3. Fluent Interface & Method Nomenclature
- **Getters:** `GetValue()` or `Getter()` (deprecated: `Get()`)
- **Setters:** `UpdateValue()` or `Setter()` (deprecated: `Update()`)  
- Chainable builder pattern: `TParametersImpl.Create(...).WithDatabase(...).Connect()`
- Hierarchy constraints: All CRUD respects `ContratoID` → `ProdutoID` → `Title`/`Name` (UNIQUE constraint)

### 4. Fallback & Automatic Source Selection
When using `IParameters` (not source-specific interfaces):
- Attempts **Database** first
- Falls back to **INI Files** on failure
- Falls back to **JSON Objects** as last resort
- **Code example:** `IParameters.Getter(TParameterScope.scSystem, 'CONFIG_KEY')` tries all sources automatically

### 5. Exception Handling
- Custom exception hierarchy: `EParametersException` (base)
  - `EParametersDatabase`, `EParametersInifiles`, `EParametersJsonObject`
  - `EParametersValidation`, `EParametersNotFound`, etc.
- **Always catch source-specific exceptions** when calling specific interfaces
- Example: `IParametersDatabase.List()` raises `EParametersDatabase` on error

## Building & Testing

### Build Tasks
- **FPC Debug:** `FPC: Compilar (Debug)` - Generates `.dcu` files, debug symbols enabled (`-gl -gw`)
- **FPC Release:** `FPC: Compilar (Release)` - Optimization enabled (`-O3`)
- **Clean Compiled:** `FPC: Limpar Arquivos Compilados` - Removes all `.dcu`, `.exe`, `.o`, `.ppu`

### Output Directories
- Debug: `Compiled/DCU/Debug/win64/`, `Compiled/EXE/Debug/win64/`
- Release: `Compiled/DCU/Release/win64/`, `Compiled/EXE/Release/win64/`

### Example Project for Testing
- **Location:** `Exemplo/Project1.dpr`
- **Coverage:** 8 complete CRUD test scenarios, 8 usage examples
- **Status:** All basic CRUD operations verified ✅

### Pending Tests (~1% remaining)
- Thread-safety stress tests (~85% of remaining work)
- Integration tests under high load
- Multi-database provider edge cases

## Database Support

### Supported Engines
- **UNIDAC** (primary)
- **FireDAC** (secondary)
- **Zeos** (fallback)

### Supported Databases
PostgreSQL, MySQL, SQL Server, SQLite, FireBird, Access, ODBC

### Connection Pattern
```pascal
var LParams: IParameters;
begin
  LParams := TParametersImpl.Create()
    .WithDatabaseEngine(TDatabaseEngine.deUNIDAC)
    .WithDatabase(TDatabaseType.dtPostgres, 'host=localhost;user=app;password=*');
  if LParams.Connect() then
    ShowMessage(LParams.Getter(scSystem, 'APP_NAME'));
end;
```

## File Organization

### Structure
```
src/
  ├── Paramenters/
  │   ├── Commons/        → Types, Consts, Exceptions
  │   ├── Database/       → Database adapter (4,912 lines)
  │   ├── IniFiles/       → INI file adapter (1,476 lines)
  │   ├── JsonObject/     → JSON adapter (2,264 lines)
  │   ├── Attributes/     → RTTI mapping (v2.0+)
  │   ├── Parameters.Interfaces.pas
  │   └── Parameters.pas
  ├── View/               → GUI components
  └── Paramenters.Database.inc    → Include file for database config
```

### Include Files
- **`Paramenters.Database.inc`** - Database connection parameters (shared across units)
- **`Paramenters.Defines.inc`** - Compiler defines

## Common Tasks

### Adding a New Parameter Source
1. Create new unit in `src/Paramenters/` (e.g., `Parameters.XML.pas`)
2. Implement interface: `IParametersXML = interface(IParametersBase)`
3. Implement class: `TParametersXML(TInterfacedObject, IParametersXML)`
4. Add to factory in `Parameters.pas`: `function WithXMLSource(...): IParametersImpl`
5. **Do NOT export implementation** - only interface in `Parameters.Interfaces.pas`

### Modifying Database Adapter
- **File:** `src/Paramenters/Database/Parameters.Database.pas` (4,912 lines)
- **Key Methods:** `Connect()`, `List()`, `Get()`, `Insert()`, `Update()`, `Delete()`
- **Thread Safety:** Always wrap logic in `FLock.Acquire` / `FLock.Release` blocks
- **Testing:** Use `Exemplo/Project1.dpr` test scenarios

### Debugging Build Issues
- **FPC not found:** Check `D:\fpc\fpc\bin\x86_64-win64\fpc.exe` exists
- **Unit not found:** Verify `-Fu` paths in build task include `src/`, `src/Modulo/`, `src/View/`
- **Linker errors:** Check `.dcu` output `-FU` path matches project structure

## Version Info
- **Current:** v1.0.3 (Released 03/01/2026)
- **Previous:** v1.0.2 (Nomenclature changes: `Get()` → `Getter()`)
- **Compatibility:** 100% backward compatible via deprecated methods

## References
- **Full Docs:** [README.md](../../README.md) (3,252 lines)
- **Change Log:** [CHANGELOG.md](../../CHANGELOG.md)
- **Test Scenarios:** [Exemplo/README_RoteiroTestes.md](../../Exemplo/README_RoteiroTestes.md)
- **Developer Rules:** [.cursor/rules/Inicial.mdc](.cursor/rules/Inicial.mdc)
