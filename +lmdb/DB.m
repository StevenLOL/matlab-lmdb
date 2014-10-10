classdef DB < handle
%DB LMDB wrapper.
%
% % Open and close.
% database = lmdb.DB('./db');
% clear database;
%
% % Read and write.
% database.put('key1', 'value1');
% database.put('key2', 'value2');
% value1 = database.get('key1');
% database.remove('key1');
%
% % Iterator.
% database.each(@(key, value) disp([key, ':', 'value']));
% count = database.reduce(@(key, value, count) count + 1, 0);
%
% See also lmdb

properties (Access = private)
  id_ % ID of the session.
end

methods
  function this = DB(filename, varargin)
  %DB Create a new database.
  %
  % database = lmdb.DB('./db')
  % database = lmdb.DB('./db', 'RDONLY', true, ...)
  %
  % Options
  %   'MODE' default 0664
  %   'FIXEDMAP' default false
  %   'NOSUBDIR' default false
  %   'NOSYNC'  default false
  %   'RDONLY', default false
  %   'NOMETASYNC' default false
  %   'WRITEMAP'  default false
  %   'MAPASYNC' default false
  %   'NOTLS' default false
  %   'NOLOCK', default false
  %   'NORDAHEAD' default false
  %   'NOMEMINIT' default false
  %   'REVERSEKEY'  default false
  %   'DUPSORT' default false
  %   'INTEGERKEY' default false
  %   'DUPFIXED'  default false
  %   'INTEGERDUP'  default false
  %   'REVERSEDUP'  default false
  %   'CREATE'  default true unless 'RDONLY' specified
    assert(isscalar(this));
    assert(ischar(filename));
    this.id_ = LMDB_('new', filename, varargin{:});
  end

  function delete(this)
  %DELETE Destructor.
    assert(isscalar(this));
    LMDB_('delete', this.id_);
  end

  function result = get(this, key)
  %GET Query a record.
    assert(isscalar(this));
    result = LMDB_('get', this.id_, key);
  end

  function put(this, key, value, varargin)
  %PUT Save a record in the database.
  %
  % Options
  %   'NODUPDATA' default false
  %   'NOOVERWRITE' default false
  %   'RESERVE' default false
  %   'APPEND' default false
    assert(isscalar(this));
    LMDB_('put', this.id_, key, value, varargin{:});
  end

  function remove(this, key, varargin)
  %REMOVE Remove a record.
    assert(isscalar(this));
    LMDB_('remove', this.id_, key, varargin{:});
  end

  function each(this, func)
  %EACH Apply a function to each record.
  %
  % Example: show each record.
  %
  % database.each(@(key, value) disp([key, ': ', value]))
    assert(isscalar(this));
    assert(ischar(func) || isa(func, 'function_handle'));
    assert(abs(nargin(func)) > 1);
    LMDB_('each', this.id_, func);
  end

  function result = reduce(this, func, initial_value)
  %REDUCE Apply an accumulation function to each record.
  %
  % Example: counting the number of 'foo' in the records.
  %
  % database.reduce(@(key, val, accum) accum + strcmp(val, 'foo'), 0)
    assert(isscalar(this));
    assert(ischar(func) || isa(func, 'function_handle'));
    assert(abs(nargin(func)) > 2 && abs(nargout(func)) > 0);
    result = LMDB_('reduce', this.id_, func, initial_value);
  end
end

end
